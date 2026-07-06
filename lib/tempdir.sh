#!/usr/bin/env bash
# lib/tempdir.sh — create a temp dir with guaranteed cleanup on exit.
# Usage:
#   . lib/tempdir.sh
#   tmp=$(make_tempdir)   # sets EXIT trap to clean it up
# The trap is appended, so multiple calls compose correctly.

_TEMPDIRS=()

_tempdir_cleanup() {
    local d
    for d in "${_TEMPDIRS[@]}"; do
        [[ -d $d ]] && rm -rf "$d"
    done
}

trap _tempdir_cleanup EXIT

make_tempdir() {
    local d
    d=$(mktemp -d)
    _TEMPDIRS+=("$d")
    printf '%s\n' "$d"
}
