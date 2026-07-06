# Exercises 07-networking

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Fetch a health endpoint
Write a script that uses `curl` to fetch an HTTP health endpoint with a timeout and exits non-zero if the server returns an error.

## 2. Check whether a TCP port is open
Use `nc` to test whether `host:port` is reachable and print a friendly message for open vs closed.

## 3. Run a remote command over SSH
Write a small wrapper that runs `uptime` on a remote host and prints a clear error if SSH fails.
