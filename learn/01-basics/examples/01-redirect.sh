#!/usr/bin/env bash
set -euo pipefail

# Demonstrate the three standard streams and how to combine them.

echo "this is stdout"
echo "this is stderr" >&2

# Merge both into one file — correct order
{ echo "out"; echo "err" >&2; } > /tmp/combined.log 2>&1
cat /tmp/combined.log

# Wrong order (stderr does NOT reach the file) — uncomment to see the difference
# { echo "out"; echo "err" >&2; } 2>&1 > /tmp/wrong.log
