# Lời giải 04 · I/O và process

## 1.
Vòng `while` chạy trong subshell (vế phải pipe), nên `lines` tăng bên trong subshell rồi biến mất khi subshell thoát.

Fix A — process substitution:
```sh
lines=0
while read -r _; do lines=$((lines+1)); done < <(find . -type f)
echo "$lines"
```

Fix B — đếm không cần loop:
```sh
find . -type f | wc -l
```

## 2.
```sh
#!/usr/bin/env bash
set -euo pipefail
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for url in "$@"; do
    curl -sSL "$url" -o "$tmp/$(basename "$url")"
done
tar -C "$tmp" -czf out.tar.gz .
```

## 3.
```sh
xargs -P10 -n1 -I{} bash -c '
    url=$1
    if status=$(curl -sSI "$url" 2>/dev/null | sed -n "1s/\r$//p"); [[ -n $status ]]; then
        printf "%s\n" "$status"
    else
        printf "curl failed for %s\n" "$url" >&2
        exit 1
    fi
' _ {} < urls.txt
```

## 4.
```sh
trap 'echo stopping; exit 0' INT
while true; do sleep 1; done
```

## 5.
```sh
# Fix A: NUL delimiter
find . -name '*.log' -print0 | xargs -0 rm

# Fix B: dùng find trực tiếp
find . -name '*.log' -delete
```
