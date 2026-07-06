#!/usr/bin/env bash
set -euo pipefail

# Portable in-place sed that works on both GNU (Linux) and BSD (macOS) sed.
# Usage: ./03-portable-sed-inplace.sh <expression> <file>
# Example: ./03-portable-sed-inplace.sh 's/foo/bar/g' notes.txt

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <sed-expr> <file>" >&2
    exit 2
fi

expr=$1
file=$2

# The -i.bak trick works on both GNU and BSD sed.
# Then delete the backup so caller doesn't see it.
sed -i.bak "$expr" "$file"
rm -f "$file.bak"

echo "Rewrote $file"
