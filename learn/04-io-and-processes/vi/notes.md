# 04 · I/O và process — subshell, xargs, trap, signal, job

## Mục tiêu

Sau bài này bạn sẽ:

- Đoán được đoạn nào chạy trong subshell, đoạn nào không (bug scope biến!).
- Chạy song song bằng `xargs -P` và background job (`&`, `wait`).
- Dọn file tạm an toàn với `trap`.
- Xử lý signal (`SIGINT`, `SIGTERM`) để script thoát sạch.

## 1. Subshell

Subshell là process bash con. Biến gán trong subshell **không** tồn tại trong parent.

```sh
( cd /tmp; ls )         # subshell tường minh với ()
cd /tmp; ls             # cùng shell — cwd thay đổi cho caller
```

**Bug hay gặp nhất**: pipe vào `while read`.

```sh
count=0
seq 1 5 | while read -r n; do
    count=$((count + 1))
done
echo "$count"           # → 0. Vòng while chạy trong subshell!
```

Cách fix:

```sh
# Fix 1: process substitution giữ loop trong shell hiện tại
while read -r n; do
    count=$((count + 1))
done < <(seq 1 5)
echo "$count"           # → 5

# Fix 2: bật lastpipe (bash 4.2+, không dùng trong interactive)
shopt -s lastpipe
seq 1 5 | while read -r n; do count=$((count + 1)); done
echo "$count"           # → 5
```

## 2. `xargs` — build lệnh từ input

```sh
find . -name '*.log' | xargs gzip           # gzip mọi match
find . -name '*.log' -print0 | xargs -0 gzip    # NUL-separated (an toàn với space)

echo "1 2 3" | xargs -n1 echo               # 1 arg mỗi lần gọi
seq 1 10 | xargs -P4 -I{} curl -s "http://api/{}"    # 4 worker song song
```

Nguyên tắc:
- Ưu tiên `-print0 | xargs -0` — dạng mặc định phân cách whitespace sẽ vỡ với tên file có space.
- `-n1` gọi lệnh 1 lần mỗi argument (an toàn hơn).
- `-P N` chạy N invocation song song. Concurrency rẻ.

## 3. Background job

```sh
long_task &                 # chạy nền
pid=$!                      # PID của job vừa background
wait "$pid"                 # chờ nó xong
wait                        # chờ TẤT CẢ background job

# Fan out rồi join
for host in a b c d; do
    ping -c1 "$host" &
done
wait
echo "all done"
```

## 4. `trap` — dọn dẹp khi exit / signal

```sh
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT           # luôn chạy, kể cả lỗi hay Ctrl-C

# Nhiều signal
trap 'echo "interrupted" >&2; exit 130' INT TERM
```

Nguyên tắc:
- Luôn trap `EXIT` khi tạo file tạm.
- Trap `INT TERM` khi script làm gì đó bạn muốn huỷ sạch (tải dài, chạy server).
- Đặt `trap` **ngay sau** khi tạo resource — trước bất kỳ lệnh nào có thể fail.

## 5. Command substitution & process substitution

```sh
result=$(cmd)               # bắt stdout của cmd vào biến

diff <(sort a) <(sort b)    # process substitution: mỗi <(...) trông như 1 file
```

Process substitution rất hữu ích khi so sánh output stream mà không cần file tạm.

## 6. Quản lý script đang chạy

```sh
jobs                        # liệt kê background job trong shell này
fg %1                       # kéo job 1 lên foreground
bg %1                       # tiếp tục ở background
kill %1                     # kill job 1
Ctrl-Z                      # suspend foreground job
```

## Đọc thêm

- [topics/debugging](../../../topics/debugging/README.md)
- `man bash` — mục `SIGNAL`, `JOB CONTROL`, `SHELL EXECUTION ENVIRONMENT`.
