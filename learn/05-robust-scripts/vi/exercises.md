# Bài tập 05 · Script chắc chắn

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Chẩn đoán fail âm thầm
```sh
#!/usr/bin/env bash
count=$(grep foo huge.log | wc -l)
echo "$count matches"
```
Chuyện gì xảy ra nếu `huge.log` không tồn tại? Fix để script fail rõ ràng.

## 2. Guard env bắt buộc
Viết script yêu cầu `DB_URL` và `API_KEY` phải set. Nếu thiếu, exit với message có ích trước khi làm bất cứ việc gì.

## 3. Default an toàn
Thêm chế độ `--dry-run` (mặc định off) vào 1 script. Khi on, in ra sẽ làm gì nhưng không thay đổi thật.

## 4. Bootstrap idempotent
Viết script tạo `/opt/myapp` nếu chưa có, tạo user `myapp` nếu chưa có, cài systemd unit. Chạy 2 lần phải no-op.

## 5. Atomic swap
2 file `a.json` và `b.json` cần đổi chỗ. Chỉ với bash + `mv`, hãy quyết định xem có làm atomic thật sự được không. Nếu không, giải thích vì sao và đưa ra cách gần đúng an toàn nhất.
