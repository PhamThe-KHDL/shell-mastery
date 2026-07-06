# 10-cron-and-scheduling

## Goal
- Learn how shell scripts behave differently once they run on a timer instead of in your terminal.
- Practice writing cron-friendly scripts with explicit environment, logging, and locking.

## 1. Cron changes the environment

The biggest cron bug is not the cron expression. It is assuming cron looks like your interactive shell.

Under cron, scripts often have:

- a smaller `$PATH`
- a different current directory
- no TTY
- fewer environment variables

That means scripts should prefer:

```sh
/absolute/path/to/script.sh
PATH=/usr/bin:/bin
```

and should log clearly when assumptions are missing.

## 2. Read cron lines left to right

Classic cron uses five time fields:

```cron
30 2 * * * /path/to/job.sh
```

That means “run at 02:30 every day.”

The command part should almost always use absolute paths.

## 3. Logging matters more than interactivity

When a scheduled job fails, you do not get a terminal.
So your script needs to leave evidence:

```sh
30 2 * * * /path/to/job.sh >> /var/log/job.log 2>&1
```

You want:

- stdout and stderr captured somewhere
- timestamps inside the script or via the logger
- explicit non-zero exits on failure

## 4. Prevent overlap with `flock`

If a job takes longer than expected, cron may start the next run before the previous one finished.

Basic fix:

```sh
flock /tmp/my-job.lock /path/to/job.sh
```

This is one of the most valuable habits for scheduled shell automation.

## 5. Alternatives to cron

Cron is not the only scheduler:

- `at` for one-off delayed jobs
- systemd timers for modern Linux services

You do not need to master them now, but you should know they exist because they often give better logging and supervision than classic cron.

## 6. Platform caveats

This lesson uses classic cron because the mental model is widely useful, but schedulers vary by platform:

- Linux commonly has `cron`, `crond`, and systemd timers.
- macOS still has cron, but `launchd` is the platform-native scheduler.
- `flock` is common on Linux and may be missing on macOS by default; if so, use another lock strategy rather than assuming it exists everywhere.

The robust habit is not "memorize one scheduler." It is "make environment, logging, and overlap control explicit no matter which scheduler runs the script."

## Further reading
- `projects/backup-tool` as a natural candidate for scheduled execution.
- `ROADMAP.md` for future lock helpers such as `lib/lock.sh`.
