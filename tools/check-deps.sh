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

echo "Checking tools:"
check bash       "bash 4+ recommended (macOS default is 3.2; brew install bash)"
check shellcheck "brew install shellcheck"
check bats       "brew install bats-core"
check shfmt      "brew install shfmt (optional — script formatter)"

if [[ ${#missing[@]} -gt 0 ]]; then
    echo
    echo "Missing ${#missing[@]} tool(s). Install and re-run." >&2
    exit 1
fi
echo
echo "✅ All required tools installed."
