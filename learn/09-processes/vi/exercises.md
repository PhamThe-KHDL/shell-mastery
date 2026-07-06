# Bài tập 09-processes

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Tìm process đang chạy
Viết lệnh tìm mọi process `ssh` đang chạy và chỉ in PID.

## 2. Chờ background jobs
Khởi chạy hai lệnh `sleep` ở background và đợi cả hai xong trước khi in `done`.

## 3. Dừng process graceful
Viết wrapper gửi `TERM`, đợi một chút, rồi chỉ dùng `KILL` nếu thật sự cần.
