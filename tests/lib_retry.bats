#!/usr/bin/env bats

setup() {
    load '../lib/retry.sh'
}

@test "retry: succeeds on first attempt" {
    run retry 3 1 true
    [ "$status" -eq 0 ]
}

@test "retry: fails after max attempts" {
    run retry 2 0 false
    [ "$status" -ne 0 ]
}

@test "retry: succeeds on second attempt" {
    counter_file=$(mktemp)
    echo 0 > "$counter_file"
    flaky() {
        local n
        n=$(cat "$counter_file")
        echo $((n + 1)) > "$counter_file"
        [[ $n -ge 1 ]]
    }
    export -f flaky
    export counter_file
    run retry 3 0 bash -c 'flaky'
    [ "$status" -eq 0 ]
    rm -f "$counter_file"
}
