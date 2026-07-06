# Lời giải 12-dates-and-times

## 1. In timestamp ISO 8601

```bash
date -u +%Y-%m-%dT%H:%M:%SZ
```

`-u` ép dùng UTC. Format string này tạo ra timestamp ổn định, sort được, và dễ dùng giữa nhiều hệ thống.

## 2. Tạo filename có ngày giờ

```bash
stamp=$(date -u +%Y%m%d-%H%M%S)
echo "backup-${stamp}.tar.gz"
```

Format này gọn, sortable, và an toàn cho filename vì không có khoảng trắng hay dấu `:`.

## 3. So sánh hai epoch

```bash
a=1720000000
b=1720000060

if (( b > a )); then
    echo "later"
else
    echo "not later"
fi
```

Khi cả hai giá trị đã ở epoch seconds, không còn gì đặc biệt nữa. So sánh số nguyên thông thường chính là công cụ đúng nhất.
