# Lời giải 05 · Script chắc chắn

## 1.
Không có `pipefail`, việc `grep` fail bị `wc -l` (trả 0) che đi. Script in `0 matches` và exit 0 — nói dối âm thầm.

Fix:
```sh
#!/usr/bin/env bash
set -euo pipefail
count=$(grep -c foo huge.log)     # -c bỏ luôn pipeline
echo "$count matches"
```
Hoặc giữ pipeline nhưng thêm `set -o pipefail`.

## 2.
```sh
#!/usr/bin/env bash
set -euo pipefail
: "${DB_URL:?DB_URL is required}"
: "${API_KEY:?API_KEY is required}"
# ... work ...
```

## 3.
```sh
dry_run=0
[[ ${1:-} == --dry-run ]] && { dry_run=1; shift; }

run() { (( dry_run )) && echo "DRY: $*" || "$@"; }

run rm -rf /some/path
run systemctl restart myapp
```

## 4.
```sh
[[ -d /opt/myapp ]] || mkdir -p /opt/myapp
id -u myapp &>/dev/null || useradd --system myapp
install -m0644 myapp.service /etc/systemd/system/myapp.service
systemctl daemon-reload
```
Mỗi check là 1 guard; mỗi lệnh install là idempotent tự nhiên.

## 5.
```sh
mv a.json a.json.swap
mv b.json a.json
mv a.json.swap b.json
```
`mv` cùng filesystem là atomic. Caller hoặc thấy cặp cũ, hoặc thấy cặp mới — không bao giờ thấy file thiếu.
