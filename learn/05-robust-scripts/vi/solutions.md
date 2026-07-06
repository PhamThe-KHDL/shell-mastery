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
#!/usr/bin/env bash
set -euo pipefail

install -d -m0755 /opt/myapp

if ! id -u myapp >/dev/null 2>&1; then
    useradd --system --home /opt/myapp --shell /usr/sbin/nologin myapp
fi

unit=/etc/systemd/system/myapp.service
if ! cmp -s myapp.service "$unit"; then
    install -m0644 myapp.service "$unit"
    systemctl daemon-reload
fi
```
`install -d` chạy lại vẫn an toàn, user chỉ được tạo nếu còn thiếu, và `daemon-reload` chỉ chạy khi file unit thật sự đổi. Nhờ vậy lần chạy thứ hai mới là no-op đúng nghĩa nếu máy đã ở đúng trạng thái mong muốn.

## 5.
```sh
mv a.json a.json.swap
mv b.json a.json
mv a.json.swap b.json
```
Đây là cách đổi chỗ ngắn nhất trong thực tế, nhưng **không** atomic thật sự nếu xét cả cặp file. Mỗi lệnh `mv` riêng lẻ trên cùng filesystem là atomic, nhưng chuỗi ba bước này vẫn có trạng thái trung gian để caller nhìn thấy tên file mới/cũ lẫn lộn.

Chỉ với bash + `mv` thì không có cách swap hai path hoàn toàn atomic. Muốn atomic ở mức tổng thể, bạn phải đổi giao diện, ví dụ:

- dùng một symlink ổn định trỏ tới file versioned rồi thay symlink một cách atomic
- đặt file vào một thư mục cha rồi swap cả thư mục bằng một lần rename
- dùng tool hoặc filesystem primitive hỗ trợ exchange-style rename
