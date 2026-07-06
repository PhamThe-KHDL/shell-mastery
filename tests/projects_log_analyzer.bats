#!/usr/bin/env bats

ANALYZE=projects/log-analyzer/analyze.sh

setup() {
    log=$(mktemp)
    cat > "$log" <<'EOF'
10.0.0.1 - - [10/Oct/2024:13:55:36 +0000] "GET /index.html HTTP/1.1" 200 512 "-" "curl/8"
10.0.0.1 - - [10/Oct/2024:13:55:37 +0000] "GET /about HTTP/1.1" 200 400 "-" "curl/8"
10.0.0.2 - - [10/Oct/2024:13:55:38 +0000] "GET /index.html HTTP/1.1" 404 100 "-" "curl/8"
10.0.0.3 - - [10/Oct/2024:13:55:39 +0000] "POST /api/x HTTP/1.1" 500 100 "-" "curl/8"
10.0.0.3 - - [10/Oct/2024:13:55:40 +0000] "POST /api/x HTTP/1.1" 500 100 "-" "curl/8"
EOF
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
