#!/usr/bin/env bash
set -euo pipefail

# Run a command under a lockfile.
# Usage: ./03-flock-run.sh <lockfile> <cmd> [args...]

lockfile=${1:?usage: $0 <lockfile> <cmd> [args...]}
shift

flock "$lockfile" "$@"
