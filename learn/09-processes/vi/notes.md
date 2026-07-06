# 09-processes

## Mục tiêu
- Hiểu các lệnh ở mức process khi script bắt đầu chạy unattended.
- Học cách inspect, signal, background, và ưu tiên tài nguyên an toàn.

## 1. Inspect trước, kill sau

Khi một process “trông như bị treo”, đừng nhảy ngay vào `kill -9`.
Hãy inspect trước:

```sh
ps -ef | grep '[s]sh'
pgrep ssh
lsof -p "$pid"
```

`pgrep` là cách gọn nhất để tìm process theo tên. `lsof` cho biết process đang giữ file hoặc socket nào.

## 2. Background job vẫn là trách nhiệm của bạn

Thêm `&` chỉ làm command chạy nền. Bạn vẫn phải quản lý nó:

```sh
sleep 10 &
pid=$!
wait "$pid"
```

`$!` là PID của process vừa được đưa xuống background gần nhất.

Nếu khởi chạy nhiều job, hãy lưu từng PID và `wait` có chủ đích.

## 3. Signal nên escalate theo thứ tự

Trình tự mặc định:

1. `TERM` — yêu cầu dừng lịch sự
2. chờ một chút
3. `KILL` chỉ khi process phớt lờ `TERM`

Pattern này tránh làm hỏng state hoặc để lại file ghi dở trong khi process vẫn có thể shutdown sạch.

## 4. Job sống lâu và detach

- `nohup cmd &` giúp job sống tiếp khi bạn đóng terminal
- `disown` xoá job khỏi shell job table
- `wait` là cách script đồng bộ với child processes

Những công cụ này quan trọng khi script chạy dưới cron, CI, hoặc supervisor.

## 5. Priority và troubleshoot

Khi job quá nặng, đừng tối ưu mù:

```sh
nice -n 10 my_job
ionice -c3 my_job
```

Và khi process hành xử kỳ lạ:

- `strace` cho bạn syscall
- `lsof` cho bạn open file/socket
- `ps`/`top` cho bạn CPU và memory pressure

Bạn chưa cần nhớ hết flag ngay lúc này; chỉ cần biết mỗi tool trả lời kiểu câu hỏi nào.

## Đọc thêm
- Xem lại `04-io-and-processes` để ôn nền tảng jobs và traps.
- Đọc `projects/` để thấy script cleanup khi exit.
