#!/usr/bin/env bash
set -euo pipefail

# Mirror one directory into another.
# Usage: ./03-rsync-copy.sh <src-dir> <dest-dir>

src=${1:?usage: $0 <src-dir> <dest-dir>}
dest=${2:?usage: $0 <src-dir> <dest-dir>}

rsync -a "$src"/ "$dest"/
