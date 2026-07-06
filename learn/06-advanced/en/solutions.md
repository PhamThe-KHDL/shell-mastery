# Solutions 06 · Advanced

These solutions assume Bash 4+ because they use associative arrays, `mapfile`, and namerefs. On stock macOS Bash 3.2, use a newer Bash first.

## 1.
```sh
declare -A seen
while IFS= read -r line; do
    [[ -v seen[$line] ]] && continue
    seen[$line]=1
    printf '%s\n' "$line"
done
```

## 2.
```sh
path="/var/log/app/access.log"
dir=${path%/*}
file=${path##*/}
stem=${file%.*}
ext=${file##*.}
echo "dir=$dir file=$file stem=$stem ext=$ext"
```

## 3.
```sh
line='[2024-01-15T10:30:45Z] user=alice action=login'
if [[ $line =~ ^\[([^\]]+)\][[:space:]]user=([^[:space:]]+)[[:space:]]action=(.+)$ ]]; then
    ts=${BASH_REMATCH[1]}
    user=${BASH_REMATCH[2]}
    action=${BASH_REMATCH[3]}
fi
```

## 4.
```sh
top_n() {
    local -n src=$1 out=$2
    local n=$3
    mapfile -t sorted < <(printf '%s\n' "${src[@]}" | sort -rn)
    out=("${sorted[@]:0:n}")
}

nums=(3 1 4 1 5 9 2 6 5 3)
top_n nums biggest 3
echo "${biggest[*]}"    # 9 6 5
```

## 5.
Parsing deeply nested JSON. Bash has no native JSON support; you'd shell out to `jq` on every extraction, and joining fields across records requires either associative arrays keyed by strings or a lot of `paste`/`awk` gymnastics. Python's `json` module reads the file once into a dict and lets you write straightforward `data["users"][0]["email"]`.
