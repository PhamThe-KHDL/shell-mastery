#!/usr/bin/env bash
# lib/retry.sh — retry với exponential backoff.
# Usage: retry <max_attempts> <initial_delay> <cmd> [args...]
# Ví dụ:  retry 5 1 curl -fsS https://example.com

retry() {
    local max=$1 delay=$2
    shift 2
    local attempt=1
    while (( attempt <= max )); do
        if "$@"; then
            return 0
        fi
        if (( attempt == max )); then
            return 1
        fi
        sleep "$delay"
        delay=$(( delay * 2 ))
        attempt=$(( attempt + 1 ))
    done
}
