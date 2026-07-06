#!/usr/bin/env bash
set -euo pipefail

# Start two jobs and wait for both.

sleep 1 &
pid1=$!
sleep 2 &
pid2=$!

wait "$pid1" "$pid2"
echo "both jobs finished"
