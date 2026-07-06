#!/usr/bin/env bats

setup() {
    load '../lib/strings.sh'
}

@test "trim: strips leading and trailing whitespace" {
    result=$(trim "   hello world   ")
    [ "$result" = "hello world" ]
}

@test "trim: preserves inner whitespace" {
    result=$(trim "  a  b  ")
    [ "$result" = "a  b" ]
}

@test "lower/upper" {
    [ "$(lower 'HeLLo')" = "hello" ]
    [ "$(upper 'HeLLo')" = "HELLO" ]
}

@test "starts_with / ends_with / contains" {
    run starts_with "abc" "abcdef"
    [ "$status" -eq 0 ]
    run starts_with "xyz" "abcdef"
    [ "$status" -ne 0 ]
    run ends_with "def" "abcdef"
    [ "$status" -eq 0 ]
    run contains "cd" "abcdef"
    [ "$status" -eq 0 ]
}

@test "join" {
    [ "$(join , a b c)" = "a,b,c" ]
    [ "$(join ' -> ' one two three)" = "one -> two -> three" ]
    [ "$(join , alone)" = "alone" ]
    [ "$(join ,)" = "" ]
}
