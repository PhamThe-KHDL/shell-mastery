# Lời giải 07-networking

## 1.
Dùng `curl -fsS --max-time 5 URL` rồi kiểm tra exit code.

## 2.
`nc -z HOST PORT` là probe đơn giản nhất; in trạng thái theo success/failure.

## 3.
Bọc `ssh "$host" uptime` trong `if ! ...; then ... fi` để lỗi mạng/xác thực được xử lý rõ ràng.
