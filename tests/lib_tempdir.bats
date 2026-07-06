#!/usr/bin/env bats

setup() {
    load '../lib/tempdir.sh'
}

@test "make_tempdir: creates a directory" {
    dir=$(make_tempdir)
    [[ -d "$dir" ]]
}

@test "tempdir trap: preserves an existing EXIT trap" {
    run bash -c '
        set -euo pipefail
        trap '\''echo first'\'' EXIT
        . lib/tempdir.sh
        trap -p EXIT
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"first; _tempdir_cleanup"* ]]
}

@test "tempdir trap: composes with a later EXIT trap" {
    run bash -c '
        set -euo pipefail
        . lib/tempdir.sh
        trap '\''echo later; _tempdir_cleanup'\'' EXIT
        trap -p EXIT
    '
    [ "$status" -eq 0 ]
    [[ "$output" == *"later; _tempdir_cleanup"* ]]
}
