# estic Backup
This script runs a restic backup and remove snapshots according to a policy.
In order for this script to work two environment vaiables must be set:
- **RESTIC_PASSWORD**: the restic repository password (or read https://restic.readthedocs.io/en/latest/faq.html#how-can-i-specify-encryption-passwords-automatically).
- **MY_RESTIC_LOGS_PATH**: the path where to save logs. For example: /home/paolo/restic/logs.

**WARNING**: This script prunes ond backups! Be careful not to delete backups that you need.
Customize the removing policy according to https://restic.readthedocs.io/en/latest/060_forget.html#removing-snapshots-according-to-a-policy

## Usage
Run (or place in the crontab): `./backup.sh [REPOSITORY] [FOLDER_PATH] [HEALTHCHECKS_ID]`

Where:
- [REPOSITORY] is the the restic repository
- [FOLDER_PATH] is the folder path to backup
- [HEALTHCHECKS_ID] (optional) healthchecks.io ID
  
Example: `./backup.sh /my-restic-repo /path/to/backup 0000000-healthchecks.io-id-000000`

### Excluding folders
To exclude a folder you can place an empty file called ".resticignore" inside it.

## Running the script automatically
To run this script automatically you could add the following line to crontab:

`30 3 * * * /path/to/script/backup.sh /my-restic-repo /path/to/backup 0000000-healthchecks.io-id-000000`
R
