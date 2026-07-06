#!/usr/bin/env bash
set -euo pipefail

# Pass arrays into functions by reference (bash 4.3+).

require_bash_43() {
    if (( BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 3) )); then
        echo "This example requires bash 4.3+. You have $BASH_VERSION." >&2
        exit 1
    fi
}
require_bash_43

# Append items to the array named by $1.
push() {
    local -n arr=$1
    shift
    arr+=("$@")
}

# Return the sum of a numeric array via $2 (nameref out-param).
sum_into() {
    local -n src=$1 out=$2
    local total=0
    for n in "${src[@]}"; do total=$((total + n)); done
    # shellcheck disable=SC2034  # `out` is a nameref — writes to caller's variable
    out=$total
}

nums=(10 20 30)
push nums 40 50
echo "nums = ${nums[*]}"

sum_into nums total
echo "total = $total"
