# 11-json-and-yaml

## Mục tiêu
- Học cách shell script hiện đại làm việc với dữ liệu có cấu trúc từ API và file cấu hình.
- Biết khi nào `jq`/`yq` là đủ và khi nào bài toán đã vượt khỏi shell.

## 1. Đừng parse JSON bằng `grep`

Cách này rất mong manh:

```sh
curl ... | grep '"name"' | cut ...
```

JSON là dữ liệu có cấu trúc. Hãy dùng `jq`:

```sh
curl -fsS URL | jq -r '.name'
```

Như vậy bạn giữ đúng rule về quoting, escaping, và nesting.

## 2. `jq` là ngôn ngữ filter

Những pattern cốt lõi:

```sh
jq -r '.name'
jq -r '.items[]'
jq -r '.items[] | .id'
```

Hãy nghĩ `jq` như “chọn, biến đổi, in ra” cho JSON.

Trong shell script, `-r` rất quan trọng vì nó in raw string thay vì chuỗi còn bọc JSON quotes.

## 3. YAML dùng cùng mental model

Với lookup config đơn giản, `yq` hoạt động gần như `jq`:

```sh
yq -r '.app.port' config.yml
```

Như vậy là đủ cho rất nhiều automation shell khi bạn chỉ cần 1-2 giá trị config chứ chưa muốn kéo cả runtime lớn hơn vào.

## 4. Biết lúc nào nên dừng

Shell + `jq` rất hợp khi:

- bạn chỉ cần một field
- bạn lặp qua array nhỏ
- bạn lọc output API trong pipeline

Nó trở nên khó chịu khi:

- JSON lồng quá sâu
- bạn cần nhiều nhánh logic
- bạn cần data structure thật qua nhiều bước

Đó là lúc Python thường đơn giản hơn “shell thông minh quá mức”.

## Đọc thêm
- `resources.md` cho tài liệu ngoài về `jq` và structured-data tooling.
- Các item tương lai `lib/json.sh` và `lib/http.sh` trong `ROADMAP.md`.
