#!/usr/bin/env bash
set -euo pipefail

# Write output atomically: produce to a temp file, mv into place at the end.
# A crash mid-write leaves the destination untouched.
# Usage: ./02-atomic-write.sh <destination>

dest=${1:?usage: $0 <destination>}

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# ---- produce the output ----
{
    echo "generated at $(date -u +%FT%TZ)"
    seq 1 10
} > "$tmp"

# Simulate a random failure — uncomment to test
# (( RANDOM % 2 )) && exit 1

mv "$tmp" "$dest"
trap - EXIT
echo "wrote $dest"
