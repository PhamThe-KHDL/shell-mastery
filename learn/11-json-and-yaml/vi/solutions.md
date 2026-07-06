# Lời giải 11-json-and-yaml

## 1. Lấy một field từ JSON

```bash
jq -r '.name' repo.json
```

Dùng `-r` để output là text thuần như `shell-mastery`, thay vì chuỗi JSON có dấu ngoặc kép như `"shell-mastery"`.

## 2. Lặp qua array an toàn

```bash
jq -r '.[]' urls.json | while IFS= read -r url; do
    echo "$url"
done
```

Điểm quan trọng là `while IFS= read -r`, không phải `for url in $(...)`. Cách này vẫn đúng kể cả khi một URL có khoảng trắng hoặc ký tự lạ.

## 3. Đọc một giá trị YAML

```bash
yq -r '.app.port' config.yml
```

Đây chính là pattern tương tự `jq`: trỏ vào nested field cần lấy rồi in ở dạng raw để shell script xung quanh sử dụng.
