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

Bạn có thể đưa dữ liệu vào `jq` từ file hoặc từ stdin:

```sh
jq -r '.name' payload.json
curl -fsS URL | jq -r '.items[] | .id'
```

Như vậy shell logic vẫn đơn giản. Hãy để `jq` lo việc parse JSON; shell chỉ lo phần control flow xung quanh.

## 3. Array và loop cần làm cẩn thận

Đây là pattern không an toàn:

```sh
for x in $(jq -r '.urls[]' file.json); do
    echo "$x"
done
```

Word splitting sẽ vỡ ngay khi một phần tử có dấu cách hoặc tab. Hãy ưu tiên loop theo từng dòng:

```sh
jq -r '.urls[]' file.json | while IFS= read -r url; do
    echo "checking $url"
done
```

Cách này giữ nguyên từng phần tử JSON.

Nếu cần lấy nhiều field cùng lúc, hãy để `jq` serialize theo định dạng thân thiện với shell:

```sh
jq -r '.items[] | [.name, .port] | @tsv' file.json |
while IFS=$'\t' read -r name port; do
    echo "$name listens on $port"
done
```

## 4. Thiếu dữ liệu và lỗi là chuyện bình thường

Dữ liệu thực tế hiếm khi hoàn hảo. Hãy quyết định rõ nếu key bị thiếu thì script phải làm gì:

```sh
jq -er '.token' config.json >/dev/null
```

Với `-e`, `jq` sẽ trả về non-zero nếu kết quả là false hoặc null. Đây thường là điều bạn muốn khi script yêu cầu field đó phải tồn tại.

Nếu thiếu dữ liệu là chấp nhận được, hãy đặt default ngay trong `jq`:

```sh
jq -r '.port // 8080' config.json
```

Như vậy logic mặc định nằm sát chỗ đọc dữ liệu.

## 5. YAML dùng cùng mental model

Với lookup config đơn giản, `yq` hoạt động gần như `jq`:

```sh
yq -r '.app.port' config.yml
```

Như vậy là đủ cho rất nhiều automation shell khi bạn chỉ cần 1-2 giá trị config chứ chưa muốn kéo cả runtime lớn hơn vào.

Nhưng YAML có vài góc cạnh cần cẩn thận:

- indentation chính là cấu trúc
- các giá trị như `yes`, `no`, hoặc ngày tháng có thể bị auto-typed
- YAML nhiều document cần filter cẩn thận hơn

Nếu file config ngày càng lớn, thường sẽ sạch hơn nếu load một lần bằng Python thay vì rải nhiều lệnh `yq` trong shell script dài.

## 6. Biết lúc nào nên dừng

Shell + `jq` rất hợp khi:

- bạn chỉ cần một field
- bạn lặp qua array nhỏ
- bạn lọc output API trong pipeline

Nó trở nên khó chịu khi:

- JSON lồng quá sâu
- bạn cần nhiều nhánh logic
- bạn cần data structure thật qua nhiều bước

Đó là lúc Python thường đơn giản hơn “shell thông minh quá mức”.

Ranh giới thực tế là thế này: dùng shell khi JSON chỉ là một chặng trong pipeline, không phải khi JSON trở thành toàn bộ application state của bạn.

## Đọc thêm
- `resources.md` cho tài liệu ngoài về `jq` và structured-data tooling.
- Các item tương lai `lib/json.sh` và `lib/http.sh` trong `ROADMAP.md`.
