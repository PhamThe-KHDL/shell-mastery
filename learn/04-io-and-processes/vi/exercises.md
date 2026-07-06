# Bài tập 04 · I/O và process

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Giải thích bug
```sh
lines=0
find . -type f | while read -r _; do lines=$((lines+1)); done
echo "$lines"
```
Vì sao in ra 0? Cho 2 cách fix.

## 2. Temp dir an toàn
Viết script tải (hoặc `curl`) 3 URL vào 1 thư mục tạm rồi gzip-tar. Thư mục tạm phải được xoá dù script thoát cách nào.

## 3. Song song hoá
Có 100 URL trong 1 file, mỗi dòng 1 URL. Chạy `curl -sI` cho tất cả, chỉ giữ status line, 10 worker song song. Output là 1 status line mỗi URL, thứ tự tuỳ ý.

## 4. Cancel sạch
Viết vòng `while true; sleep 1` sao cho khi Ctrl-C thì in `"stopping"` và exit 0.

## 5. Find + xargs safety
`find . -name '*.log' | xargs rm` fail với file tên `my log.log`. Fix bằng 2 cách khác nhau.
