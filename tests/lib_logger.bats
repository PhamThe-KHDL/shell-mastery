#!/usr/bin/env bats

setup() {
    load '../lib/logger.sh'
}

@test "log_info: writes to stderr" {
    run bash -c '. lib/logger.sh; log_info "hello" 2>&1 >/dev/null'
    [ "$status" -eq 0 ]
    [[ "$output" == *"hello"* ]]
}

@test "LOG_LEVEL=warn suppresses info" {
    result=$(LOG_LEVEL=warn bash -c '. lib/logger.sh; log_info "shhh" 2>&1 >/dev/null')
    [ -z "$result" ]
}

@test "LOG_LEVEL=warn allows warn" {
    result=$(LOG_LEVEL=warn bash -c '. lib/logger.sh; log_warn "heads-up" 2>&1 >/dev/null')
    [[ "$result" == *"heads-up"* ]]
}

@test "log_error is always shown" {
    result=$(LOG_LEVEL=error bash -c '. lib/logger.sh; log_error "boom" 2>&1 >/dev/null')
    [[ "$result" == *"boom"* ]]
}
