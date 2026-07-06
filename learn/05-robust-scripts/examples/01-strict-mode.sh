#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Show that undefined variables now fail loudly.
# Try commenting out `set -u` to see it silently expand to "".

: "${NAME:?NAME must be set — try: NAME=alice $0}"

echo "hello, $NAME"
