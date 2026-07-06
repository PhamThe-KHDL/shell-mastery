# Solutions 10-cron-and-scheduling

## 1. Write a cron entry

```cron
30 2 * * * /opt/tools/backup.sh >>/var/log/backup.log 2>&1
```

The first five fields are minute, hour, day-of-month, month, day-of-week. The command should use absolute paths because cron often runs with a tiny `PATH`.

## 2. Make a script cron-safe

```bash
#!/usr/bin/env bash
set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin
export PATH

echo "running with PATH=$PATH"
echo "running in $(pwd)"

/usr/bin/find /var/log -type f -name '*.log' -mtime +7 -print
```

The exact command does not matter much. The important fixes are:

- set `PATH` deliberately, including your real package-manager locations
- call external programs by absolute path when practical
- print enough context that cron mail or logs tell you what environment the job saw

## 3. Prevent overlap

```cron
*/5 * * * * flock /tmp/backup.lock -c '/opt/tools/backup.sh >>/var/log/backup.log 2>&1'
```

If one run takes longer than five minutes, the next run will fail to acquire the lock and exit instead of starting a second overlapping copy.
