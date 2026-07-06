#!/usr/bin/env bash
set -euo pipefail

# Run a quick command on a remote host.
# Usage: ./03-remote-uptime.sh <host>

host=${1:?usage: $0 <host>}

ssh "$host" uptime
