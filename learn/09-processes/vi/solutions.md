# Lời giải 09-processes

## 1.
Dùng `pgrep ssh` hoặc `ps -ef | grep '[s]sh'` tùy bộ công cụ bạn giả định.

## 2.
Lưu PID background bằng `$!` rồi gọi `wait "$pid1" "$pid2"`.

## 3.
Gửi `kill -TERM "$pid"` trước, sleep ngắn, rồi `kill -0` để xem có cần escalate không.
