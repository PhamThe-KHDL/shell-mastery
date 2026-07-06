# Lời giải 09-processes

## 1. Tìm process đang chạy

```bash
pgrep ssh
```

Nếu máy không có `pgrep`, fallback portable là:

```bash
ps -ef | grep '[s]sh' | awk '{print $2}'
```

Mẹo dấu ngoặc vuông giúp lệnh `grep ssh` không tự match chính nó.

## 2. Chờ background jobs

```bash
sleep 2 &
pid1=$!

sleep 3 &
pid2=$!

wait "$pid1" "$pid2"
echo done
```

`$!` lấy PID của background job vừa chạy gần nhất. `wait` sẽ block cho tới khi cả hai job xong và trả về non-zero nếu một job fail.

## 3. Dừng process một cách nhẹ nhàng

```bash
#!/usr/bin/env bash
set -euo pipefail

pid=${1:?usage: stop-gracefully.sh PID}

kill -TERM "$pid"
sleep 2

if kill -0 "$pid" 2>/dev/null; then
    kill -KILL "$pid"
fi
```

`TERM` là yêu cầu dừng lịch sự. `KILL` là phương án cuối cùng. `kill -0` không giết process; nó chỉ kiểm tra PID đó còn tồn tại và có thể nhận signal hay không.
