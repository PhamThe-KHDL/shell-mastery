#!/usr/bin/env bash
set -euo pipefail

# Common file-path manipulations without external tools.

path="/var/log/app/access.log.2024-01-15.gz"

echo "full     : $path"
echo "dirname  : ${path%/*}"
echo "basename : ${path##*/}"
echo "stem     : ${path##*/}"     # then strip extensions:
name=${path##*/}
echo "no .gz   : ${name%.gz}"
echo "date part: ${name%.*}"; echo "         : ${name%.*.gz}"
echo "extension: ${name##*.}"

# Substitutions
url="https://api.example.com/v1/users"
echo "no proto : ${url#https://}"
echo "host     : $(echo "${url#https://}" | cut -d/ -f1)"
