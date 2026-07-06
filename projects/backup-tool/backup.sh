#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") -s SOURCE -d DEST -n NAME [-k KEEP] [--dry-run]

  -s, --source PATH      source directory (required)
  -d, --dest PATH        destination directory (required)
  -n, --name NAME        archive base name (required)
  -k, --keep N           number of recent archives to keep (default 5)
      --dry-run          print actions, change nothing
  -h, --help             show this help
EOF
    exit 2
}

source=""
dest=""
name=""
keep=5
dry_run=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--source) source=$2; shift 2 ;;
        -d|--dest)   dest=$2;   shift 2 ;;
        -n|--name)   name=$2;   shift 2 ;;
        -k|--keep)   keep=$2;   shift 2 ;;
        --dry-run)   dry_run=1; shift ;;
        -h|--help)   usage ;;
        *) echo "Unknown argument: $1" >&2; usage ;;
    esac
done

[[ -n $source && -n $dest && -n $name ]] || usage
[[ -d $source ]] || { echo "source not a directory: $source" >&2; exit 1; }
[[ -d $dest   ]] || { echo "dest not a directory: $dest"     >&2; exit 1; }
[[ $keep =~ ^[0-9]+$ ]] || { echo "-k must be a non-negative integer" >&2; exit 2; }

run() {
    if (( dry_run )); then
        echo "DRY: $*"
    else
        "$@"
    fi
}

timestamp=$(date -u +%Y%m%d-%H%M%S)
archive="${name}-${timestamp}.tar.gz"
final="${dest%/}/${archive}"

# --- atomic tar to temp then mv ---
tmp=$(mktemp "${dest%/}/.${name}.XXXXXX.tar.gz")
trap '[[ -f "$tmp" ]] && rm -f "$tmp"' EXIT

echo "creating $final from $source" >&2
if (( dry_run )); then
    echo "DRY: tar -C $(dirname "$source") -czf $tmp $(basename "$source")"
    echo "DRY: mv $tmp $final"
else
    tar -C "$(dirname "$source")" -czf "$tmp" "$(basename "$source")"
    mv "$tmp" "$final"
    trap - EXIT
fi

# --- retention: keep the N newest matching archives ---
mapfile -t archives < <(find "$dest" -maxdepth 1 -name "${name}-*.tar.gz" -type f | sort -r)
if (( ${#archives[@]} > keep )); then
    for old in "${archives[@]:keep}"; do
        run rm -f "$old"
    done
fi

echo "done: $final" >&2
