# Solutions 04 · I/O and processes

## 1.
The `while` loop runs in a subshell (right side of a pipe), so `lines` is incremented inside the subshell and discarded when it exits.

Fix A — process substitution:
```sh
lines=0
while read -r _; do lines=$((lines+1)); done < <(find . -type f)
echo "$lines"
```

Fix B — count without a loop:
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
xargs -P10 -I{} -a urls.txt curl -sI {} | grep -E '^HTTP/'
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

# Fix B: use find directly
find . -name '*.log' -delete
```
