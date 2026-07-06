# Bài tập 10-cron-and-scheduling

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Viết một cron entry
Viết cron line chạy backup script mỗi ngày lúc 02:30 và append output vào log file.

## 2. Làm script cron-safe
Cập nhật một script để dùng absolute path và in rõ các giả định về environment.

## 3. Chống chạy chồng
Dùng `flock` để cùng một scheduled job không thể chạy hai lần cùng lúc.
