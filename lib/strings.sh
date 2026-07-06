#!/usr/bin/env bash
# lib/strings.sh — small string helpers using parameter expansion (no forks).

# trim leading/trailing whitespace
trim() {
    local s=$1
    s=${s#"${s%%[![:space:]]*}"}
    s=${s%"${s##*[![:space:]]}"}
    printf '%s' "$s"
}

# lowercase (bash 4+)
lower() { printf '%s' "${1,,}"; }

# uppercase (bash 4+)
upper() { printf '%s' "${1^^}"; }

# starts_with prefix string
starts_with() { [[ $2 == "$1"* ]]; }

# ends_with suffix string
ends_with() { [[ $2 == *"$1" ]]; }

# contains needle haystack
contains() { [[ $2 == *"$1"* ]]; }

# join separator element...
# Example: join , a b c → a,b,c
join() {
    local sep=$1; shift
    local out=""
    local first=1
    local x
    for x in "$@"; do
        if (( first )); then out=$x; first=0
        else out+="$sep$x"
        fi
    done
    printf '%s' "$out"
}
