#!/usr/bin/env bash
set -euo pipefail

# Build a timestamped filename.
# Usage: ./02-dated-filename.sh [prefix]

prefix=${1:-backup}
stamp=$(date -u +%Y%m%d-%H%M%S)

echo "${prefix}-${stamp}.tar.gz"
