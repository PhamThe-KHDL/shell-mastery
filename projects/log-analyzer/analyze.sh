#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [-n N] [file]

Analyze a Combined Log Format access log from stdin or FILE.

  -n N      show top-N entries per section (default 10)
  -h        show this help
EOF
    exit 2
}

top=10
while getopts ":n:h" opt; do
    case $opt in
        n)  top=$OPTARG ;;
        h)  usage ;;
        *)  usage ;;
    esac
done
shift $((OPTIND - 1))

[[ $top =~ ^[0-9]+$ && $top -gt 0 ]] || { echo "-n must be a positive integer" >&2; exit 2; }

# Work off a temp copy so we can stream multiple sections.
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

if [[ $# -eq 0 ]]; then
    cat > "$tmp"
else
    cat "$1" > "$tmp"
fi

total=$(wc -l < "$tmp" | tr -d ' ')

echo "==== Summary ===="
echo "total requests: $total"
echo "unique IPs:     $(awk '{print $1}' "$tmp" | sort -u | wc -l | tr -d ' ')"

echo
echo "==== Top $top clients ===="
awk '{print $1}' "$tmp" | sort | uniq -c | sort -rn | head -"$top" \
    | awk '{printf "  %-6s %s\n", $1, $2}'

echo
echo "==== Status code distribution ===="
awk '{print $9}' "$tmp" | sort | uniq -c | sort -rn \
    | awk '{printf "  %-6s %s\n", $1, $2}'

echo
echo "==== Top $top paths ===="
# path is field 7 in Combined Log Format after splitting the quoted request field
awk '{print $7}' "$tmp" | sort | uniq -c | sort -rn | head -"$top" \
    | awk '{printf "  %-6s %s\n", $1, $2}'

echo
echo "==== 5xx errors ===="
awk '$9 ~ /^5/' "$tmp" || true
