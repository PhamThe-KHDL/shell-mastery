#!/usr/bin/env bash
set -euo pipefail

# Two ways a function returns data: exit code vs stdout.

# Returns via exit code — use in `if`.
is_number() {
    [[ $1 =~ ^-?[0-9]+$ ]]
}

# Returns via stdout — capture with $().
double() {
    local n=$1
    echo $((n * 2))
}

for arg in "$@"; do
    if is_number "$arg"; then
        printf '%s → %s\n' "$arg" "$(double "$arg")"
    else
        printf '%s is not a number\n' "$arg" >&2
    fi
done
