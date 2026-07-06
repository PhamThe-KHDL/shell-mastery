#!/usr/bin/env bash
# lib/tempdir.sh — create a temp dir with guaranteed cleanup on exit.
# Usage:
#   . lib/tempdir.sh
#   tmp=$(make_tempdir)   # sets EXIT trap to clean it up
# Existing EXIT trap handlers are preserved.

_TEMPDIRS=()

_tempdir_cleanup() {
    local d
    for d in "${_TEMPDIRS[@]}"; do
        [[ -d $d ]] && rm -rf "$d"
    done
}

_tempdir_install_exit_trap() {
    local existing
    existing=$(trap -p EXIT || true)

    if [[ -z $existing ]]; then
        trap '_tempdir_cleanup' EXIT
        return
    fi

    if [[ $existing == *"_tempdir_cleanup"* ]]; then
        return
    fi

    existing=${existing#trap -- \'}
    existing=${existing%\' EXIT}
    # shellcheck disable=SC2064  # We intentionally preserve the current EXIT trap body.
    trap "${existing}; _tempdir_cleanup" EXIT
}

_tempdir_install_exit_trap

make_tempdir() {
    local d
    d=$(mktemp -d)
    _TEMPDIRS+=("$d")
    printf '%s\n' "$d"
}
