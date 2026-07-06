#!/usr/bin/env bash
# lib/logger.sh — logger tối giản có level và màu.
# Source: `. lib/logger.sh`
# Level qua env: LOG_LEVEL=debug|info|warn|error (mặc định info).

_log_level_num() {
    case ${1:-info} in
        debug) echo 10 ;;
        info)  echo 20 ;;
        warn)  echo 30 ;;
        error) echo 40 ;;
        *)     echo 20 ;;
    esac
}

_log() {
    local level=$1 color=$2 msg
    shift 2
    msg=$*
    local cur threshold
    cur=$(_log_level_num "$level")
    threshold=$(_log_level_num "${LOG_LEVEL:-info}")
    (( cur < threshold )) && return 0
    if [[ -t 2 ]]; then
        printf '\033[%sm[%s]\033[0m %s\n' "$color" "$level" "$msg" >&2
    else
        printf '[%s] %s\n' "$level" "$msg" >&2
    fi
}

log_debug() { _log debug 36 "$@"; }
log_info()  { _log info  32 "$@"; }
log_warn()  { _log warn  33 "$@"; }
log_error() { _log error 31 "$@"; }
