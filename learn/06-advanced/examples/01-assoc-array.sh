#!/usr/bin/env bash
set -euo pipefail

# Group log lines by level using an associative array.
# Usage: ./01-assoc-array.sh app.log
# where each line looks like: [LEVEL] message...

file=${1:?usage: $0 <logfile>}

declare -A count

while IFS= read -r line; do
    if [[ $line =~ ^\[([A-Z]+)\] ]]; then
        level=${BASH_REMATCH[1]}
        count[$level]=$(( ${count[$level]:-0} + 1 ))
    fi
done < "$file"

for level in "${!count[@]}"; do
    printf '%-8s %d\n' "$level" "${count[$level]}"
done | sort -k2 -rn
