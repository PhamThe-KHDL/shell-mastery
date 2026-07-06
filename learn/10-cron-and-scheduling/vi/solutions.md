# Lời giải 10-cron-and-scheduling

## 1.
Điểm quan trọng là 5 trường cron và dùng absolute path trong command.

## 2.
Thiết lập hoặc validate `PATH`, tránh relative path, và log stderr vào nơi bạn thực sự đọc.

## 3.
Bọc command thật bằng `flock /tmp/job.lock -c '...'` hoặc pattern lock bằng fd.
