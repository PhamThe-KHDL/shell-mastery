# Exercises 10-cron-and-scheduling

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Write a cron entry
Write a cron line that runs a backup script every day at 02:30 and appends output to a log file.

## 2. Make a script cron-safe
Update a script so it uses absolute paths and prints its environment assumptions clearly.

## 3. Prevent overlap
Use `flock` so the same scheduled job cannot run twice at once.
