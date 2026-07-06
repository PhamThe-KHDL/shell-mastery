#!/usr/bin/env bash
set -euo pipefail

# Compare two epoch timestamps.
# Usage: ./03-compare-epoch.sh <a> <b>

a=${1:?usage: $0 <a> <b>}
b=${2:?usage: $0 <a> <b>}

if (( b > a )); then
    echo "b is later"
else
    echo "b is not later"
fi
