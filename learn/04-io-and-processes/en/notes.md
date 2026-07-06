# 04 · I/O and processes — subshells, xargs, trap, signals, jobs

## Goal

After this lesson you can:

- Predict what runs in a subshell and what doesn't (variable scope bug!).
- Parallelize with `xargs -P` and background jobs (`&`, `wait`).
- Clean up temp files reliably with `trap`.
- Handle signals (`SIGINT`, `SIGTERM`) so scripts exit gracefully.

## 1. Subshells

A subshell is a child bash process. Variables assigned in a subshell **do not** exist in the parent.

```sh
( cd /tmp; ls )         # explicit subshell with ()
cd /tmp; ls             # same shell — cwd changes for the caller
```

**The most common bug**: piping to `while read`.

```sh
count=0
seq 1 5 | while read -r n; do
    count=$((count + 1))
done
echo "$count"           # → 0. The while loop ran in a subshell!
```

Fixes:

```sh
# Fix 1: process substitution keeps loop in current shell
while read -r n; do
    count=$((count + 1))
done < <(seq 1 5)
echo "$count"           # → 5

# Fix 2: enable lastpipe (bash 4.2+, non-interactive)
shopt -s lastpipe
seq 1 5 | while read -r n; do count=$((count + 1)); done
echo "$count"           # → 5
```

## 2. `xargs` — build commands from input

```sh
find . -name '*.log' | xargs gzip           # gzip every match
find . -name '*.log' -print0 | xargs -0 gzip    # NUL-separated (safe for spaces)

echo "1 2 3" | xargs -n1 echo               # one arg per invocation
seq 1 10 | xargs -P4 -I{} curl -s "http://api/{}"    # 4 parallel workers
```

Rules:
- Prefer `-print0 | xargs -0` — the default whitespace-delimited form breaks on filenames with spaces.
- `-n1` invokes the command once per argument (safer, no accidental overflow).
- `-P N` runs N invocations in parallel. Cheap concurrency.

## 3. Background jobs

```sh
long_task &                 # run in background
pid=$!                      # PID of the last backgrounded job
wait "$pid"                 # block until it finishes
wait                        # wait for ALL background jobs

# Fan out, then join
for host in a b c d; do
    ping -c1 "$host" &
done
wait
echo "all done"
```

## 4. `trap` — run cleanup on exit / signal

```sh
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT           # always runs, even on error or Ctrl-C

# Multiple signals
trap 'echo "interrupted" >&2; exit 130' INT TERM
```

Rules:
- Always trap `EXIT` when you create temp files.
- Trap `INT TERM` when the script does something you want to cancel cleanly (a long download, a running server).
- Put the `trap` **immediately after** creating the resource — before any command that can fail.

## 5. Command substitution & process substitution

```sh
result=$(cmd)               # captures cmd's stdout into a variable

diff <(sort a) <(sort b)    # process substitution: each <(...) looks like a filename
```

Process substitution is a game-changer for comparing stream outputs without temp files.

## 6. Managing running scripts

```sh
jobs                        # list background jobs in this shell
fg %1                       # bring job 1 to foreground
bg %1                       # resume in background
kill %1                     # terminate job 1
Ctrl-Z                      # suspend the current foreground job
```

## Further reading

- [topics/debugging](../../../topics/debugging/en/README.md)
- `man bash` — sections `SIGNAL`, `JOB CONTROL`, `SHELL EXECUTION ENVIRONMENT`.
