#!/usr/bin/env bash
# snippets/getopts.sh — template for short-flag parsing with getopts.
# Copy into your script and adapt.

set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [options] <input>

Options:
  -v          verbose
  -n NAME     required name
  -c COUNT    count (default: 1)
  -h          show this help
EOF
    exit 2
}

verbose=0
name=""
count=1

while getopts ":vn:c:h" opt; do
    case $opt in
        v)  verbose=1 ;;
        n)  name=$OPTARG ;;
        c)  count=$OPTARG ;;
        h)  usage ;;
        \?) echo "Unknown option: -$OPTARG" >&2; usage ;;
        :)  echo "Option -$OPTARG requires an argument" >&2; usage ;;
    esac
done
shift $((OPTIND - 1))

# Positional args
[[ $# -ge 1 ]] || usage
input=$1

# Required flags
[[ -n $name ]] || { echo "-n NAME is required" >&2; usage; }

(( verbose )) && echo "verbose on: name=$name count=$count input=$input" >&2

# ... your logic here ...
