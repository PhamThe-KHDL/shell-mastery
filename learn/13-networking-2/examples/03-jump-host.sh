#!/usr/bin/env bash
set -euo pipefail

# Print an SSH jump-host pattern.
# Usage: ./03-jump-host.sh <bastion> <target>

bastion=${1:?usage: $0 <bastion> <target>}
target=${2:?usage: $0 <bastion> <target>}

echo "ssh -J $bastion $target"
