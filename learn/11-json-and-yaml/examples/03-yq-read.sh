#!/usr/bin/env bash
set -euo pipefail

# Read a nested YAML key.
# Usage: ./03-yq-read.sh <config.yml>

file=${1:?usage: $0 <config.yml>}

yq -r '.app.port' "$file"
