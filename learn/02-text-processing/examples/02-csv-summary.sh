#!/usr/bin/env bash
set -euo pipefail

# Summarize a CSV: total, average, and max of the 2nd numeric column.
# Assumes a header row.
# Usage: ./02-csv-summary.sh data.csv

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <file.csv>" >&2
    exit 2
fi

awk -F, 'NR>1 {
    total += $2
    if ($2 > max) max = $2
    n++
}
END {
    if (n == 0) { print "empty"; exit }
    printf "rows=%d total=%.2f avg=%.2f max=%.2f\n", n, total, total/n, max
}' "$1"
