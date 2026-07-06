#!/usr/bin/env bash
set -euo pipefail

# Print each JSON array element on its own line.
# Usage: echo '["a","b"]' | ./02-jq-array-lines.sh

jq -r '.[]'
