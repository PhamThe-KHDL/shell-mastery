#!/usr/bin/env bash
set -euo pipefail

# Show assumptions that often break under cron.

echo "PWD=$PWD"
echo "HOME=${HOME:-unset}"
echo "PATH=${PATH:-unset}"
