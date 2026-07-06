# Bài tập 06 · Nâng cao

Làm xong đối chiếu với [`solutions.md`](solutions.md).

Lưu ý: bài 1 và 4 cần Bash 4+ (`declare -A`, `local -n`). Bash 3.2 mặc định trên macOS sẽ không chạy nguyên xi các ví dụ này.

## 1. Dedup giữ thứ tự
Cho stream các dòng, in mỗi dòng chỉ 1 lần khi xuất hiện lần đầu (giữ nguyên thứ tự gốc). Dùng associative array — không dùng `sort`.

## 2. Parse path
Cho `$path`, tách dir, filename (có ext), stem (không ext), và extension chỉ bằng parameter expansion.

## 3. Regex capture
Parse dòng `[2024-01-15T10:30:45Z] user=alice action=login` thành 3 biến `ts`, `user`, `action` bằng `=~`.

## 4. Function trả về array
Viết `top_n SRC_ARRAY OUT_ARRAY N` để bơm `N` phần tử lớn nhất từ array số đầu vào `SRC_ARRAY` sang `OUT_ARRAY`. Dùng nameref.

## 5. Khi nào KHÔNG dùng bash
Cho 1 ví dụ Python là lựa chọn đúng — và vì sao bản shell sẽ tệ hơn.
