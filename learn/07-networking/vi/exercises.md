# Bài tập 07-networking

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Fetch health endpoint
Viết script dùng `curl` để gọi một HTTP health endpoint có timeout và trả mã lỗi nếu server báo lỗi.

## 2. Kiểm tra TCP port
Dùng `nc` để test `host:port` có reachable không và in thông báo dễ hiểu cho trạng thái open/closed.

## 3. Chạy lệnh từ xa qua SSH
Viết wrapper nhỏ chạy `uptime` trên remote host và báo lỗi rõ ràng nếu SSH thất bại.
