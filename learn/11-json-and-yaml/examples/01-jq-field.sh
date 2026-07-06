#!/usr/bin/env bash
set -euo pipefail

# Extract one field from JSON read on stdin.
# Usage: echo '{"name":"demo"}' | ./01-jq-field.sh

jq -r '.name'
