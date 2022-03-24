#!bin/bash

# This script runs a restic backup and remove snapshots according to a policy.
# In order for this script to work two environment vaiables must be set:
# RESTIC_PASSWORD which is the restic repository password (or read https://restic.readthedocs.io/en/latest/faq.html#how-can-i-specify-encryption-passwords-automatically)
# MY_RESTIC_LOGS_PATH which is the path where to save logs. For example: /home/paolo/restic/logs

# WARNING: This script prunes ond backups! Be careful not to delete backups that you need.
# Customize the removing policy according to https://restic.readthedocs.io/en/latest/060_forget.html#removing-snapshots-according-to-a-policy

# Usage:
# ./backup.sh [REPOSITORY] [FOLDER_PATH] [HEALTHCHECKS_ID]
# [REPOSITORY] is the the restic repository
# [FOLDER_PATH] is the folder path to backup
# [HEALTHCHECKS_ID] (optional) healthchecks.io ID
# Example: ./backup.sh /my-restic-repo /path/to/backup 0000000-healthchecks.io-id-000000

# To exclude a folder you can place an empty file called ".resticignore" inside it.

# To run this script automatically you could add the following line to crontab:
# 30 3 * * * /path/to/script/backup.sh /my-restic-repo /path/to/backup 0000000-healthchecks.io-id-000000

# Get envirorment variables
source ${HOME}/.profile

# Define functions
helpFunction() {
    echo ""
    echo "Usage: $0 [REPOSITORY] [FOLDER_PATH]"
    echo "\t[REPOSITORY] is the path of the repository"
    echo "\t[FOLDER_PATH] is the folder path to backup"
    echo "\t[HEALTHCHECKS_ID] (optional) healthchecks.io ID"
    exit 1 # Exit script after printing help
}

checkInputs() {
    # Print helpFunction in case parameters are empty
    if [ -z "${REPOSITORY}" ] || [ -z "${FOLDER_PATH}" ]; then
        echo "Some or all of the parameters are empty. Exiting."
        helpFunction
    fi
}

lockFile() {
    exec 99>"${LOCKFILE}"
    flock -n 99

    RC=$?
    if [ "$RC" != 0 ]; then
        echo "This restic ${REPOSITORY} backup of ${FOLDER_PATH} is already running. Exiting."
        exit
    fi
}

startHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending start ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}/start
        echo ""
    fi
}

stopHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending stop ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}
        echo ""
    fi
}

failHealthCheck() {
    if [ -n "${HEALTHCHECKS_ID}" ]; then
        echo "Sending fail ping to healthchecks.io at $(datestring)"
        curl -m 1 -fsS --retry 5 https://hc-ping.com/${HEALTHCHECKS_ID}/fail
        echo ""
    fi
}

runBackup() {
    restic -r $REPOSITORY backup --verbose --exclude-if-present .resticignore $FOLDER_PATH
    if [ $(echo $?) -eq 1 ]; then
        echo "Fatal error detected!"
        failHealthCheck | tee -a $LOG_FILE
        echo "Cleaning up lock file and exiting."
        rm -f ${LOCKFILE} | tee -a $LOG_FILE
        exit 1
    fi
}

pruneOld() {
    echo "Prune old backups at $(datestring)"
    restic -r $REPOSITORY forget --verbose --prune --keep-last 10 --keep-hourly 1 --keep-daily 10 --keep-weekly 5 --keep-monthly 14 --keep-yearly 100
    echo "Check repository at $(datestring)"
    restic -r $REPOSITORY check --verbose
}

datestring() {
    date +%Y-%m-%d\ %H:%M:%S
}

SCRIPTNAME=$(basename $0)
REPOSITORY="$1"
FOLDER_PATH="$2"
HEALTHCHECKS_ID="$3"

# Create log file
START_TIMESTAMP=$(date +%s)
LOG_FILE="${MY_RESTIC_LOGS_PATH}/$(date +%Y-%m-%d-%H-%M-%S).log"
touch $LOG_FILE
echo "restic backup script started at $(datestring)" | tee -a $LOG_FILE
echo "REPOSITORY=${REPOSITORY}" | tee -a $LOG_FILE
echo "FOLDER_PATH=${FOLDER_PATH}" | tee -a $LOG_FILE
echo "HEALTHCHECKS_ID=${HEALTHCHECKS_ID}" | tee -a $LOG_FILE

# Start helthcheck
startHealthCheck | tee -a $LOG_FILE

# Check inputs
checkInputs | tee -a $LOG_FILE

# Create lockfile
LOCKFILE="/tmp/my_restic_backup.lock"
lockFile | tee -a $LOG_FILE

# Run the backup
runBackup | tee -a $LOG_FILE

# Prune old backups
pruneOld | tee -a $LOG_FILE

# clean up lockfile
rm -f ${LOCKFILE} | tee -a $LOG_FILE

# Stop helthcheck
stopHealthCheck | tee -a $LOG_FILE

delta=$(date -d@$(($(date +%s) - $START_TIMESTAMP)) -u +%H:%M:%S)
echo "restic backup script finished at $(datestring) in ${delta}" | tee -a $LOG_FILE
/
