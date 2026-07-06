#!/usr/bin/env bash
set -euo pipefail

# Run N tasks with 4 parallel workers. Compare wall time.

task() {
    local n=$1
    sleep 1
    echo "done $n on pid $$"
}
export -f task

echo "serial:"
time for n in 1 2 3 4 5 6 7 8; do task "$n"; done

echo
echo "parallel (4 workers):"
time printf '%s\n' 1 2 3 4 5 6 7 8 | xargs -P4 -I{} bash -c 'task "$@"' _ {}
