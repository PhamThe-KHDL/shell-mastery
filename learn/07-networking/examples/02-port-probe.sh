#!/usr/bin/env bash
set -euo pipefail

# Check whether a TCP port is reachable.
# Usage: ./02-port-probe.sh <host> <port>

host=${1:?usage: $0 <host> <port>}
port=${2:?usage: $0 <host> <port>}

if nc -z "$host" "$port"; then
    echo "open: $host:$port"
else
    echo "closed: $host:$port" >&2
    exit 1
fi
