#!/usr/bin/env bash
set -euo pipefail

# Archive a directory without cd'ing into it.
# Usage: ./02-tar-dir.sh <source-dir> <output.tar.gz>

src=${1:?usage: $0 <source-dir> <output.tar.gz>}
out=${2:?usage: $0 <source-dir> <output.tar.gz>}

tar -C "$(dirname "$src")" -czf "$out" "$(basename "$src")"
