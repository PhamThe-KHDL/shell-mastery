#!/usr/bin/env bash
set -euo pipefail

# Reminder snippet for tempdir-based fixtures.

cat <<'EOF'
setup() {
    tmp=$(mktemp -d)
}

teardown() {
    rm -rf "$tmp"
}
EOF
