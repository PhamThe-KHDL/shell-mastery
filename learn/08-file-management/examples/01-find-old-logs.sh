#!/usr/bin/env bash
set -euo pipefail

# Print .log files older than N days.
# Usage: ./01-find-old-logs.sh <dir> [days]

dir=${1:?usage: $0 <dir> [days]}
days=${2:-7}

find "$dir" -type f -name '*.log' -mtime +"$days"
