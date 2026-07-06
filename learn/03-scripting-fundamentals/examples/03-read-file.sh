#!/usr/bin/env bash
set -euo pipefail

# Read a file line by line — the correct way.
# NEVER use: for line in $(cat file). That word-splits.
# Usage: ./03-read-file.sh <file>

file=${1:?usage: $0 <file>}

lineno=0
while IFS= read -r line || [[ -n $line ]]; do
    lineno=$((lineno + 1))
    printf '%4d | %s\n' "$lineno" "$line"
done < "$file"
