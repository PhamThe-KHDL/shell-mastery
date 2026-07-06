# 07-networking

## Goal
- Learn the shell commands you reach for first when a script talks to the network.
- Practice fetching data safely, checking connectivity, and wrapping remote commands.

## 1. `curl` first, not `wget`

For scripts, `curl` is usually the default because it is predictable and composable:

```sh
curl -fsS --max-time 5 https://example.com/health
```

- `-f` fails on HTTP 4xx/5xx instead of printing an HTML error page and exiting 0.
- `-sS` stays quiet on success but still prints errors.
- `--max-time 5` prevents a hung endpoint from hanging your script forever.

Add retries only when the operation is safe to repeat:

```sh
curl -fsS --retry 3 --retry-delay 1 URL
```

## 2. Reachability vs correctness

“The port is open” does not mean “the service is healthy.”

- Use `nc -z host port` to check whether a TCP port is reachable.
- Use `curl` to check whether an HTTP service returns the right status and body.
- Use `dig` when the failure might be DNS rather than the service itself.

## 3. SSH as a scripting primitive

Treat SSH like a command transport:

```sh
ssh web-01 uptime
ssh db-01 'df -h /var/lib/postgresql'
scp report.txt ops@host:/tmp/
```

The same shell rules still apply:

- quote remote commands carefully
- handle exit codes explicitly
- expect auth failures, DNS failures, and timeouts

## 4. Basic debugging checklist

When a network script fails, ask in this order:

1. Did DNS resolve?
2. Is the port open?
3. Did the remote side answer?
4. Did it answer with the status I expected?
5. Is the failure transient enough to justify a retry?

## 5. Safety defaults

Good defaults for shell networking:

```sh
curl -fsS --max-time 5 URL
ssh -o BatchMode=yes host cmd
nc -z host port
```

`BatchMode=yes` matters in automation: it tells SSH not to stop for a password prompt you will never see in cron or CI.

## Further reading
- `ROADMAP.md` for how this lesson grows into `13-networking-2`.
- `topics/portability` before relying on Linux-only networking flags.
