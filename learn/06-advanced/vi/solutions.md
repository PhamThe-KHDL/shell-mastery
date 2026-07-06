# Lời giải 06 · Nâng cao

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
Parse JSON lồng sâu. Bash không có hỗ trợ JSON tự nhiên; bạn phải shell ra `jq` mỗi lần trích, và join field giữa các record đòi hỏi hoặc associative array key string hoặc gymnastics `paste`/`awk`. Module `json` của Python đọc file 1 lần vào dict rồi cho phép viết thẳng `data["users"][0]["email"]`.
