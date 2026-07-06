#!/usr/bin/env bash
set -euo pipefail

# Listen on a local port with netcat.
# Usage: ./02-nc-listen.sh [port]

port=${1:-9000}

nc -l "$port"
