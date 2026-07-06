#!/usr/bin/env bash
# snippets/argparse.sh — template for long-flag parsing (getopts can't do --long).
# Copy into your script and adapt.

set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [options] <input>

Options:
  --verbose            verbose output
  --name NAME          required name
  --count N            count (default: 1)
  --output FILE        output path
  -h, --help           show this help
EOF
    exit 2
}

verbose=0
name=""
count=1
output=/dev/stdout

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)      verbose=1; shift ;;
        --name)         name=$2; shift 2 ;;
        --name=*)       name=${1#*=}; shift ;;
        --count)        count=$2; shift 2 ;;
        --count=*)      count=${1#*=}; shift ;;
        --output)       output=$2; shift 2 ;;
        --output=*)     output=${1#*=}; shift ;;
        -h|--help)      usage ;;
        --)             shift; break ;;
        --*)            echo "Unknown option: $1" >&2; usage ;;
        *)              break ;;
    esac
done

[[ $# -ge 1 ]] || usage
input=$1

[[ -n $name ]] || { echo "--name is required" >&2; usage; }

(( verbose )) && echo "verbose on: name=$name count=$count input=$input output=$output" >&2

# ... your logic here ...
