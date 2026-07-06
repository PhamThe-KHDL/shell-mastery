#!/usr/bin/env bash
set -euo pipefail

# Print PIDs of matching processes.
# Usage: ./01-find-pids.sh <pattern>

pattern=${1:?usage: $0 <pattern>}

pgrep "$pattern"
