#!/usr/bin/env bash
set -euo pipefail

# Template: parse -v (verbose flag) and -o FILE (output flag), then an input arg.
# Try: ./01-getopts.sh -v -o /tmp/out.txt hello

usage() {
    cat >&2 <<EOF
Usage: $0 [-v] [-o FILE] INPUT
  -v         verbose
  -o FILE    output file (default: stdout)
  -h         help
EOF
    exit 2
}

verbose=0
output=/dev/stdout
while getopts ":vo:h" opt; do
    case $opt in
        v) verbose=1 ;;
        o) output=$OPTARG ;;
        h) usage ;;
        \?) echo "Unknown option: -$OPTARG" >&2; usage ;;
        :)  echo "Option -$OPTARG requires an argument" >&2; usage ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ge 1 ]] || usage
input=$1

(( verbose )) && echo "verbose on, output=$output, input=$input" >&2
echo "processed: $input" > "$output"
