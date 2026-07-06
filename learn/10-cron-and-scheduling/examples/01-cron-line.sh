#!/usr/bin/env bash
set -euo pipefail

# Print a cron line for a backup job.

echo '30 2 * * * /path/to/backup.sh -s /home/me -d /mnt/backup -n home >> /var/log/home-backup.log 2>&1'
