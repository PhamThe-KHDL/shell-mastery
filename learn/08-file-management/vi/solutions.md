# Lời giải 08-file-management

## 1. Tìm file theo tuổi

```bash
find "$dir" -type f -name '*.log' -mtime +7 -print
```

`-type f` bỏ qua thư mục, `-name '*.log'` lọc theo đuôi file, còn `-mtime +7` nghĩa là cũ hơn 7 chu kỳ 24 giờ.

## 2. Tạo archive an toàn

```bash
#!/usr/bin/env bash
set -euo pipefail

src=${1:?usage: archive-dir.sh DIR}
base=$(basename "$src")
parent=$(dirname "$src")
stamp=$(date -u +%Y%m%d)
out="${base}-${stamp}.tar.gz"

tar -C "$parent" -czf "$out" "$base"
echo "$out"
```

Ý quan trọng là `tar -C "$parent"`: nó chỉ đổi thư mục bên trong `tar`, không làm shell của caller bị đổi `pwd`.

## 3. Chỉ copy file thay đổi

```bash
rsync -a --delete "$src"/ "$dest"/
```

`-a` giữ timestamp, permission, và cấu trúc thư mục. Dấu `/` ở cuối rất quan trọng: `"$src"/` nghĩa là copy phần nội dung của thư mục. Chỉ dùng `--delete` khi bạn thực sự muốn đích trở thành bản mirror.
