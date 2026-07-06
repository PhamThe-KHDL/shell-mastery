#!/usr/bin/env bats

ANALYZE=projects/log-analyzer/analyze.sh
FIXTURE=tests/fixtures/log-analyzer.sample.log

setup() {
    log=$(mktemp)
    cp "$FIXTURE" "$log"
}

teardown() {
    rm -f "$log"
}

@test "reports total requests" {
    run "$ANALYZE" "$log"
    [ "$status" -eq 0 ]
    [[ "$output" == *"total requests: 5"* ]]
}

@test "reports unique IPs" {
    run "$ANALYZE" "$log"
    [[ "$output" == *"unique IPs:     3"* ]]
}

@test "top client is 10.0.0.1 with 2" {
    run "$ANALYZE" "$log"
    [[ "$output" == *"2      10.0.0.1"* ]]
}

@test "reports 500 errors under 5xx section" {
    run "$ANALYZE" "$log"
    [[ "$output" == *"5xx errors"* ]]
    [[ "$output" == *"/api/x"* ]]
}

@test "reads stdin when no file arg" {
    run bash -c "$ANALYZE < $log"
    [ "$status" -eq 0 ]
    [[ "$output" == *"total requests: 5"* ]]
}

@test "rejects invalid -n" {
    run "$ANALYZE" -n abc "$log"
    [ "$status" -eq 2 ]
}
