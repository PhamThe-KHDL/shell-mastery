#!/usr/bin/env bash
set -euo pipefail

# ERR trap shows which line and command failed.
# Run: ./03-err-trap.sh
# Expected: message pointing to the `false` call on line 12.

trap 'echo "ERR at line $LINENO: $BASH_COMMAND (exit $?)" >&2' ERR

echo "step 1"
echo "step 2"
false
echo "never reached"
