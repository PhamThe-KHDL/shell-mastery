# Solutions 09-processes

## 1. Find a running process

```bash
pgrep ssh
```

If `pgrep` is unavailable, the portable fallback is:

```bash
ps -ef | grep '[s]sh' | awk '{print $2}'
```

The bracket trick prevents the `grep ssh` command from matching itself.

## 2. Wait for background jobs

```bash
sleep 2 &
pid1=$!

sleep 3 &
pid2=$!

wait "$pid1" "$pid2"
echo done
```

`$!` captures the PID of the most recent background job. `wait` blocks until both jobs finish and will return non-zero if one of them failed.

## 3. Stop a process gracefully

```bash
#!/usr/bin/env bash
set -euo pipefail

pid=${1:?usage: stop-gracefully.sh PID}

kill -TERM "$pid"
sleep 2

if kill -0 "$pid" 2>/dev/null; then
    kill -KILL "$pid"
fi
```

`TERM` asks nicely. `KILL` is the last resort. `kill -0` does not stop the process; it only checks whether the PID still exists and is signalable.
