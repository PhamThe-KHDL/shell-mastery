#!/usr/bin/env bash
set -euo pipefail

# Check the tools required to work with this repo.

missing=()
check() {
    if command -v "$1" >/dev/null 2>&1; then
        printf '  ✅ %-12s %s\n' "$1" "$($1 --version 2>&1 | head -1)"
    else
        printf '  ❌ %-12s (missing — %s)\n' "$1" "$2"
        missing+=("$1")
    fi
}

warn() {
    printf '  !! %-12s %s\n' "$1" "$2"
}

echo "Checking tools:"
check bash       "bash 4+ required (macOS default is 3.2; brew install bash)"

if command -v bash >/dev/null 2>&1; then
    bash_major=$(bash -c 'printf "%s" "${BASH_VERSINFO[0]}"')
    if (( bash_major < 4 )); then
        warn bash "found bash $(bash --version | head -1); this repo requires bash 4+"
        missing+=("bash>=4")
    fi
fi

check shellcheck "brew install shellcheck"
check bats       "brew install bats-core"

if command -v shfmt >/dev/null 2>&1; then
    printf '  ✅ %-12s %s\n' "shfmt" "$(shfmt --version 2>&1 | head -1)"
else
    warn shfmt "missing (optional — script formatter, brew install shfmt)"
fi

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    echo "Missing ${#missing[@]} required tool(s). Install and re-run." >&2
    exit 1
fi
echo
echo "✅ All required tools installed."
