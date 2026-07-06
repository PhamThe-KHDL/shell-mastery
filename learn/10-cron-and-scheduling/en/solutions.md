# Solutions 10-cron-and-scheduling

## 1.
The key is the five cron fields plus absolute paths in the command.

## 2.
Set or validate `PATH`, avoid relative paths, and log stderr somewhere you will actually read.

## 3.
Wrap the real command with `flock /tmp/job.lock -c '...'` or use an fd-based lock pattern.
