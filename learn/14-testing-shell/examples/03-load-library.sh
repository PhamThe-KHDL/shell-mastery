#!/usr/bin/env bash
set -euo pipefail

# Reminder snippet for testing a sourceable library.

cat <<'EOF'
setup() {
    load '../lib/my_lib.sh'
}
EOF
