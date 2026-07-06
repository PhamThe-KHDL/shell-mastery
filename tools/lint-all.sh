#!/usr/bin/env bash
set -euo pipefail

# Run shellcheck on every .sh file in the repo.
# Non-zero exit on any warning → suitable for CI.

root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

if ! command -v shellcheck >/dev/null 2>&1; then
    echo "❌ shellcheck not installed. Try: brew install shellcheck" >&2
    exit 1
fi

# Exclude .git and node_modules. Use -exec for bash 3.2 compat (macOS default).
count=$(find . \
    -type d \( -name .git -o -name node_modules \) -prune -o \
    -type f -name '*.sh' -print | wc -l | tr -d ' ')

if [[ $count -eq 0 ]]; then
    echo "No .sh files found."
    exit 0
fi

echo "Linting $count files..."
find . \
    -type d \( -name .git -o -name node_modules \) -prune -o \
    -type f -name '*.sh' -exec shellcheck --severity=warning {} +
echo "✅ Clean."
