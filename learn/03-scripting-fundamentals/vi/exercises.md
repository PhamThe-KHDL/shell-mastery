# Bài tập 03 · Nền tảng scripting

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. FizzBuzz
In 1..30, thay bội của 3 bằng `Fizz`, của 5 bằng `Buzz`, của cả 2 bằng `FizzBuzz`.

## 2. Default an toàn
Viết function `greet` nhận 1 argument (tên). Nếu gọi không có argument, dùng `world`. Không được để việc thiếu argument làm hỏng script.

## 3. Argument parser
Viết script nhận `-n NAME` (bắt buộc) và `-c COUNT` (mặc định 1), in `hello, NAME` lặp `COUNT` lần. Reject flag lạ với usage message tử tế.

## 4. Retry có backoff
Viết function `retry MAX CMD...` chạy `CMD` tối đa `MAX` lần, sleep 1, 2, 4, ... giây giữa các lần. Trả về exit code lần cuối.

## 5. Chain vs conditional
Giải thích trong 1 câu vì sao `cmd1 && cmd2 || cmd3` KHÔNG giống if/then/else.
