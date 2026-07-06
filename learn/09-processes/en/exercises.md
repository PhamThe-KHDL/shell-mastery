# Exercises 09-processes

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Find a running process
Write a command that finds all running `ssh` processes and prints only their PIDs.

## 2. Wait for background jobs
Start two background sleeps and wait for both to finish before printing `done`.

## 3. Stop a process gracefully
Write a small wrapper that sends `TERM`, waits a bit, then escalates to `KILL` only if needed.
