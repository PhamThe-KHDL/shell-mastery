# Solutions 07-networking

## 1.
Use `curl -fsS --max-time 5 URL` and check the exit code.

## 2.
`nc -z HOST PORT` is the simplest probe; print status based on success or failure.

## 3.
Wrap `ssh "$host" uptime` in `if ! ...; then ... fi` so network/auth failures are handled explicitly.
