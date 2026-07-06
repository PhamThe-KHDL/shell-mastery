#!/usr/bin/env bash
set -euo pipefail

# Build a word-frequency table from stdin.
# Usage: ./01-frequency-count.sh < some.txt
# Or:    echo "the quick brown fox jumps over the lazy dog the end" | ./01-frequency-count.sh

tr -s '[:space:][:punct:]' '\n' \
    | tr '[:upper:]' '[:lower:]' \
    | grep -v '^$' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -10
