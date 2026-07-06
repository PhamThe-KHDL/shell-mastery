#!/usr/bin/env bash
set -euo pipefail

# Word splitting: the classic bug when you forget to quote.

files=("my file.txt" "another file.txt")

# ❌ Unquoted → 4 arguments instead of 2
echo "Unquoted:"
# shellcheck disable=SC2068  # intentionally wrong to illustrate the bug
for f in ${files[@]}; do
    echo "  [$f]"
done

# ✅ Quoted correctly → 2 arguments
echo "Quoted:"
for f in "${files[@]}"; do
    echo "  [$f]"
done
