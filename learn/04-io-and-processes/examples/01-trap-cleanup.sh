#!/usr/bin/env bash
set -euo pipefail

# Guaranteed temp-dir cleanup with trap EXIT.
# Try Ctrl-C partway through — the cleanup still runs.

tmp=$(mktemp -d)
trap 'echo "cleaning $tmp" >&2; rm -rf "$tmp"' EXIT

echo "created $tmp"
for i in 1 2 3; do
    echo "step $i" > "$tmp/step-$i"
    sleep 1
done
ls "$tmp"
