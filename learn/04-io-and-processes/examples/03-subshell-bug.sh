#!/usr/bin/env bash
set -euo pipefail

# The classic subshell scope bug and its fix.

echo "BUG: pipe into while — count stays 0"
count=0
seq 1 5 | while read -r _; do
    count=$((count + 1))
done
echo "  count = $count"

echo
echo "FIX: process substitution"
count=0
while read -r _; do
    count=$((count + 1))
done < <(seq 1 5)
echo "  count = $count"
