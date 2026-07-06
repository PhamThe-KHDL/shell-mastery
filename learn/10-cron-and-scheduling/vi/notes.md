# 10-cron-and-scheduling

## Mục tiêu
- Học cách shell script hành xử khác đi khi chạy theo lịch thay vì trong terminal.
- Luyện viết script cron-friendly với environment rõ ràng, logging, và locking.

## 1. Cron làm thay đổi môi trường chạy

Lỗi cron lớn nhất thường không nằm ở biểu thức thời gian mà ở việc bạn giả định cron giống terminal tương tác.

Dưới cron, script thường có:

- `$PATH` ngắn hơn
- current directory khác
- không có TTY
- ít environment variable hơn

Vì vậy script nên ưu tiên:

```sh
/absolute/path/to/script.sh
PATH=/usr/bin:/bin
```

và cần log rõ khi giả định môi trường không đúng.

## 2. Đọc cron line từ trái sang phải

Cron cổ điển có 5 trường thời gian:

```cron
30 2 * * * /path/to/job.sh
```

Nghĩa là “chạy lúc 02:30 mỗi ngày”.

Phần command gần như luôn nên dùng absolute path.

## 3. Logging quan trọng hơn interactivity

Khi scheduled job fail, bạn không có terminal nhìn trực tiếp.
Vì vậy script phải để lại dấu vết:

```sh
30 2 * * * /path/to/job.sh >> /var/log/job.log 2>&1
```

Bạn cần:

- stdout và stderr được capture ở đâu đó
- timestamp trong log hoặc từ logger
- exit code khác 0 khi lỗi

## 4. Chống overlap bằng `flock`

Nếu một job chạy lâu hơn dự kiến, cron có thể khởi động run tiếp theo khi run trước chưa xong.

Cách sửa cơ bản:

```sh
flock /tmp/my-job.lock /path/to/job.sh
```

Đây là một trong những thói quen có giá trị nhất khi tự động hóa shell theo lịch.

## 5. Các lựa chọn khác ngoài cron

Cron không phải scheduler duy nhất:

- `at` cho job một lần trong tương lai
- systemd timers cho service Linux hiện đại

Bạn chưa cần master chúng ngay, nhưng nên biết chúng tồn tại vì nhiều khi logging và supervision tốt hơn cron cổ điển.

## 6. Lưu ý về khác biệt nền tảng

Bài này dùng cron cổ điển vì mental model của nó hữu ích ở rất nhiều nơi, nhưng scheduler thật sự sẽ khác theo nền tảng:

- Linux thường có `cron`, `crond`, và systemd timers
- macOS vẫn có cron, nhưng `launchd` mới là scheduler bản địa
- `flock` phổ biến trên Linux nhưng có thể không có sẵn trên macOS; khi đó hãy chọn chiến lược lock khác thay vì giả định nó luôn tồn tại

Thói quen robust không phải là "thuộc một scheduler duy nhất", mà là "dù scheduler nào chạy script thì environment, logging, và chống overlap vẫn phải được khai báo rõ ràng".

## Đọc thêm
- `projects/backup-tool` là ứng viên tự nhiên để chạy theo lịch.
- Xem `ROADMAP.md` cho helper tương lai như `lib/lock.sh`.
