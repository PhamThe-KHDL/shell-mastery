# Exercises 05 · Robust scripts

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Diagnose the silent failure
```sh
#!/usr/bin/env bash
count=$(grep foo huge.log | wc -l)
echo "$count matches"
```
What happens if `huge.log` doesn't exist? Fix it so the script fails loudly.

## 2. Guard required env
Write a script that requires `DB_URL` and `API_KEY` to be set. On missing input, it must exit with a helpful message before doing any work.

## 3. Safe defaults
Add a `--dry-run` mode (default off) to a script. When on, print what would happen but change nothing.

## 4. Idempotent bootstrap
Write a script that creates `/opt/myapp` if missing, creates a user `myapp` if missing, and installs a systemd unit. Running it twice must be a no-op.

## 5. Atomic swap
Two files `a.json` and `b.json` need to swap places atomically — no window where a caller sees one file missing. Bash + `mv` only.
