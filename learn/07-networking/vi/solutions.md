# Lời giải 07-networking

## 1. Gọi health endpoint

```bash
#!/usr/bin/env bash
set -euo pipefail

url=${1:?usage: health-check.sh URL}

if curl -fsS --max-time 5 "$url" >/dev/null; then
    echo "healthy: $url"
else
    echo "unhealthy: $url" >&2
    exit 1
fi
```

`-f` khiến HTTP 4xx/5xx trả về non-zero, `-sS` giữ output gọn nhưng vẫn hiện lỗi, còn `--max-time 5` giúp script không treo vô hạn.

## 2. Kiểm tra TCP port có mở không

```bash
#!/usr/bin/env bash
set -euo pipefail

host=${1:?usage: port-check.sh HOST PORT}
port=${2:?usage: port-check.sh HOST PORT}

if nc -z "$host" "$port"; then
    echo "open: $host:$port"
else
    echo "closed or unreachable: $host:$port" >&2
    exit 1
fi
```

`nc -z` dùng netcat để probe mà không gửi dữ liệu. Trên một số hệ, bạn có thể thêm `-w 3` để có timeout rõ ràng hơn.

## 3. Chạy lệnh remote qua SSH

```bash
#!/usr/bin/env bash
set -euo pipefail

host=${1:?usage: remote-uptime.sh HOST}

if ! ssh "$host" uptime; then
    echo "ssh failed for host: $host" >&2
    exit 1
fi
```

Điểm quan trọng không phải là `uptime`, mà là failure path được viết rõ ràng. Script thật thường thêm `-o BatchMode=yes` để CI fail nhanh thay vì chờ prompt nhập mật khẩu.
