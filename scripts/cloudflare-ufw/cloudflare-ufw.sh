#!/bin/sh

# Automatically whitelist Cloudflare ips with UFW.
# This script should be runned daily with a cron job (place it in /etc/cron.daily).
# Remember to make this script executable.
# Reference: https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh

curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips

# Allow all traffic from Cloudflare IPs to 443, change at your liking
for cfip in $(cat /tmp/cf_ips)
do
  ufw allow proto tcp from $cfip to any port 443 comment 'Cloudflare IP';
  # ufw allow proto tcp from $cfip to any port 80 comment 'Cloudflare IP';
  # ufw route allow in on eth0 out on wg0 to 10.0.0.2 port 443 proto tcp from $cfip comment 'Cloudflare IP';
done

ufw reload > /dev/null
