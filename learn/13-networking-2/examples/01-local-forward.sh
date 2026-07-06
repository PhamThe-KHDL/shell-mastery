#!/usr/bin/env bash
set -euo pipefail

# Forward a local port through SSH.
# Usage: ./01-local-forward.sh <host>

host=${1:?usage: $0 <host>}

ssh -L 8080:127.0.0.1:80 "$host"
