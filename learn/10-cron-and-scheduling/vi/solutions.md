# Lời giải 10-cron-and-scheduling

## 1. Viết một cron entry

```cron
30 2 * * * /opt/tools/backup.sh >>/var/log/backup.log 2>&1
```

Năm trường đầu lần lượt là phút, giờ, ngày trong tháng, tháng, ngày trong tuần. Command nên dùng absolute path vì môi trường cron thường có `PATH` rất nghèo.

## 2. Làm script an toàn khi chạy bằng cron

```bash
#!/usr/bin/env bash
set -euo pipefail

PATH=/usr/local/bin:/usr/bin:/bin
export PATH

echo "running with PATH=$PATH"
echo "running in $(pwd)"

/usr/bin/find /var/log -type f -name '*.log' -mtime +7 -print
```

Điểm quan trọng không nằm ở lệnh `find` cụ thể, mà ở các sửa đổi sau:

- tự đặt `PATH`
- ưu tiên absolute path cho external commands
- in đủ ngữ cảnh để khi xem cron mail hoặc log bạn biết job đã chạy trong môi trường nào

## 3. Chặn job chạy chồng lên nhau

```cron
*/5 * * * * flock /tmp/backup.lock -c '/opt/tools/backup.sh >>/var/log/backup.log 2>&1'
```

Nếu một lần chạy mất hơn 5 phút, lần kế tiếp sẽ không lấy được lock và tự thoát, thay vì tạo ra một bản chạy chồng chéo thứ hai.
