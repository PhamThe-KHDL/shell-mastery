# Lời giải 08-file-management

## 1.
Bắt đầu với `find DIR -type f -name '*.log' -mtime +7`.

## 2.
Dùng `tar -C "$(dirname "$src")" -czf "$out" "$(basename "$src")"`.

## 3.
`rsync -a SRC/ DEST/` là điểm khởi đầu an toàn nhất cho incremental copy.
