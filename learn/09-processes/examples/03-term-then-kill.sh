#!/usr/bin/env bash
set -euo pipefail

# Try TERM first, escalate to KILL only if needed.
# Usage: ./03-term-then-kill.sh <pid>

pid=${1:?usage: $0 <pid>}

kill -TERM "$pid"
sleep 2

if kill -0 "$pid" 2>/dev/null; then
    kill -KILL "$pid"
fi
