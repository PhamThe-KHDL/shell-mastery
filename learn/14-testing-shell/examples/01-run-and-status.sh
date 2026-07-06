#!/usr/bin/env bash
set -euo pipefail

# Reminder snippet for common Bats patterns.

cat <<'EOF'
@test "missing required flags: exit 2" {
    run "$SCRIPT"
    [ "$status" -eq 2 ]
}
EOF
