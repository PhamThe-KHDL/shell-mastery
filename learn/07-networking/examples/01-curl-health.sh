#!/usr/bin/env bash
set -euo pipefail

# Fetch a health endpoint with sane curl defaults.
# Usage: ./01-curl-health.sh <url>

url=${1:?usage: $0 <url>}

curl -fsS --max-time 5 --retry 2 "$url"
