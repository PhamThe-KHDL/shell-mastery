# 08-file-management

## Mục tiêu
- Học các lệnh thao tác file khiến shell script thật sự hữu ích.
- Luyện cách chọn file an toàn, nén/đóng gói, và copy mà không dính footgun.

## 1. `find` mới là ngôn ngữ chọn file thật sự

Người mới hay viết `for f in $(ls ...)`; cách đó vỡ khi tên file có khoảng trắng và scale rất kém.
Hãy dùng `find`:

```sh
find logs/ -type f -name '*.log'
find . -type f -mtime +7
find src/ -type f -size +10M
```

Khi đẩy output vào lệnh khác, ưu tiên pipeline null-delimited:

```sh
find . -type f -print0 | xargs -0 rm -f
```

Đó là cách phòng thủ chuẩn trước các filename “dị”.

## 2. Quote path và dùng `--`

Với lệnh thao tác file, quote là bắt buộc:

```sh
cp "$src" "$dest"
mv "$tmp" "$final"
rm -- "$file"
```

`--` rất quan trọng khi tên file có thể bắt đầu bằng `-`. Nếu không có, filename có thể bị hiểu nhầm thành flag.

## 3. Archive mà không đổi thư mục hiện tại

Pattern an toàn rất hay dùng:

```sh
tar -C "$(dirname "$src")" -czf "$out" "$(basename "$src")"
```

Nó tốt hơn kiểu `cd "$src"; tar ...` vì:

- không làm thay đổi shell state
- chạy đúng từ bất kỳ current directory nào
- dễ bọc vào script và test hơn

## 4. `rsync` là công cụ copy mà sớm muộn bạn cũng cần

Với mirror thư mục, mặc định tốt nhất thường là `rsync -a`:

```sh
rsync -a src/ dest/
```

Nó giữ timestamp, permission, và chỉ copy phần thay đổi. Vì vậy nó hợp hơn `cp -r` cho backup hoặc sync kiểu deploy.

## 5. Tư duy xoá file an toàn

Phần nguy hiểm nhất trong script quản lý file thường không phải copy mà là delete.

Trước khi bulk delete:

1. in trước những gì sẽ bị xoá
2. lọc hẹp nhất có thể
3. ưu tiên `find ... -type f` hơn glob rộng
4. thêm `--dry-run` nếu việc xoá không tầm thường

Đó cũng là lý do các script cleanup/backup robust thường có `--dry-run`.

## Đọc thêm
- Xem `projects/backup-tool` như một ví dụ hoàn chỉnh về archive và retention.
- Đọc `topics/portability` cho khác biệt BSD vs GNU của `find`/`tar`.
