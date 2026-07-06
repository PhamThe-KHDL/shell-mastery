# Solutions 07-networking

## 1. Fetch a health endpoint

```bash
#!/usr/bin/env bash
set -euo pipefail

url=${1:?usage: health-check.sh URL}

if curl -fsS --max-time 5 "$url" >/dev/null; then
    echo "healthy: $url"
else
    echo "unhealthy: $url" >&2
    exit 1
fi
```

`-f` makes HTTP 4xx/5xx return non-zero, `-sS` keeps output quiet but still prints errors, and `--max-time 5` prevents the script from hanging forever.

## 2. Check whether a TCP port is open

```bash
#!/usr/bin/env bash
set -euo pipefail

host=${1:?usage: port-check.sh HOST PORT}
port=${2:?usage: port-check.sh HOST PORT}

if nc -z "$host" "$port"; then
    echo "open: $host:$port"
else
    echo "closed or unreachable: $host:$port" >&2
    exit 1
fi
```

`nc -z` asks netcat to probe without sending data. On some systems you may also want `-w 3` for a timeout.

## 3. Run a remote command over SSH

```bash
#!/usr/bin/env bash
set -euo pipefail

host=${1:?usage: remote-uptime.sh HOST}

if ! ssh "$host" uptime; then
    echo "ssh failed for host: $host" >&2
    exit 1
fi
```

The important part is not the command itself; it is that the failure path is explicit. A real script might add `-o BatchMode=yes` so CI jobs fail fast instead of waiting for an interactive password prompt.
