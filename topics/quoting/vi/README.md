# Topic · Quoting & word splitting

> 🌐 [English](../en/README.md) · **Tiếng Việt**

Nếu phải chọn đúng một thứ shell nâng cao để học cho kỹ, hãy chọn cái này. Quoting là thủ phạm số một của bug trong shell. Khi bạn thật sự nắm được nó, một loạt tình huống "ơ sao script chạy sai vậy?" sẽ tự động biến mất.

## Vì sao quoting quan trọng — thử ngay 30 giây

```sh
$ file="my important file.txt"
$ ls -l $file
ls: cannot access 'my': No such file or directory
ls: cannot access 'important': No such file or directory
ls: cannot access 'file.txt': No such file or directory

$ ls -l "$file"
-rw-r--r-- 1 me me 42 Oct 15 10:00 'my important file.txt'
```

Ở dòng không quote, shell đã cắt giá trị thành **ba tham số riêng** dựa vào dấu cách, rồi mới đưa cho `ls`. Lúc này `ls` tưởng bạn muốn xem ba file `my`, `important`, `file.txt`. Còn khi có quote, cả tên file được giữ nguyên là một.

Điều đáng sợ là bug kiểu này ẩn mình rất kỹ: hôm nay chạy ngon vì tên file không có dấu cách, tuần sau người dùng đặt tên "báo cáo quý 1.pdf" là vỡ. Nó cũng hay bung ra với biến môi trường "bình thường vẫn rỗng", với timestamp có dấu cách, hay với mấy đoạn lệnh bạn copy vội trên mạng.

## Quy tắc vàng

> **Mặc định luôn viết `"$var"` và `"${arr[@]}"`. Chỉ bỏ quote khi bạn thực sự CỐ Ý muốn word splitting hoặc glob.**

Trên thực tế, số lần bạn cố ý bỏ quote chỉ khoảng 5% (ví dụ muốn tách `$PATH` theo dấu `:`). 95% còn lại: cứ quote cho chắc.

## Chuyện gì xảy ra bên trong khi bạn viết `$var`

Sau khi thay giá trị của biến vào, shell làm tiếp **ba bước, theo đúng thứ tự**:

1. **Word splitting** — giá trị vừa thay bị cắt nhỏ tại mỗi ký tự nằm trong `$IFS`. Mặc định `IFS` gồm dấu cách, tab và xuống dòng, nên `"a b c"` biến thành ba "mảnh".
2. **Glob (pathname expansion)** — mỗi mảnh được đem so với tên file trong thư mục. `*` khớp mọi thứ, `?` khớp đúng một ký tự, `[abc]` khớp một trong `a`, `b`, `c`.
3. **Đưa vào lệnh** — các mảnh còn lại được truyền vào lệnh như những tham số tách biệt.

```sh
files="a.txt b.txt"

rm $files          # sau khi xử lý: rm a.txt b.txt   → 2 tham số
rm "$files"        # sau khi xử lý: rm "a.txt b.txt" → 1 tham số
```

Cả hai cách đều có thể đúng, tùy tình huống. Vấn đề là: **bạn phải chủ động chọn**, chứ đừng để nó xảy ra một cách tình cờ.

## Bảng tra nhanh

| Cách viết | Có word split? | Có glob? | Thay `$var`? | Thay `$(...)`? |
|---|:-:|:-:|:-:|:-:|
| `$var`             | ✅ | ✅ | ✅ | — |
| `"$var"`           | ❌ | ❌ | ✅ | ✅ |
| `'$var'`           | ❌ | ❌ | ❌ | ❌ |
| `${arr[*]}`        | ✅ | ✅ | ✅ | — |
| `"${arr[*]}"`      | ❌ | ❌ | dồn thành một chuỗi | — |
| `${arr[@]}`        | ✅ | ✅ | ✅ | — |
| `"${arr[@]}"`      | ❌ | ❌ | **mỗi phần tử là một tham số** | — |
| `\$var`            | — | — | ❌ (dấu $ bị escape) | — |

Gần như mỗi khi lặp qua array, thứ bạn cần là `"${arr[@]}"`.

## Những cái bẫy hay gặp (và cách thoát)

### 1. File có dấu cách khi lấy từ `$(ls)` hay `find`

```sh
# ❌ vỡ ngay khi tên file có dấu cách
for f in $(ls); do process "$f"; done

# ✅ dùng glob, tên file được giữ nguyên vẹn
for f in *; do process "$f"; done

# ✅ khi cần duyệt ngoài thư mục hiện tại, dùng find với ký tự phân cách NUL
find . -type f -print0 | while IFS= read -r -d '' f; do
    process "$f"
done
```

### 2. Tham số rỗng "bốc hơi" âm thầm

```sh
# ❌ nếu $empty chưa gán, dòng này rút gọn thành: mycmd other
mycmd $empty other

# ✅ giữ lại đúng vị trí, dù giá trị rỗng
mycmd "$empty" other
```

Hậu quả thật của lỗi này: truyền một giá trị rỗng cho `--flag` làm mọi tham số phía sau bị xô lệch. `mycmd --file "" input.txt` biến thành `mycmd --file input.txt` — và thế là script đọc nhầm file mà không hề báo lỗi.

### 3. So sánh chuỗi hỏng khi biến rỗng

```sh
$ var=
$ [ $var = foo ]     # → [: =: unary operator expected
$ [ "$var" = foo ]   # ✅ so sánh chuỗi rỗng với "foo", chạy đúng
$ [[ $var = foo ]]   # ✅ [[ ]] không word-split nên cũng ổn
```

Nhớ: `[[ ]]` "hiền" với quoting, còn `[ ]` thì không.

### 4. Gán biến không quote thường ổn — nhưng không phải luôn luôn

```sh
name=$other        # OK dù $other có dấu cách — phép gán không word-split
export A=$other    # cũng OK

# Nhưng:
declare A=$other   # ⚠ có thể bị word split ở vài phiên bản bash
                   # → nên viết declare A="$other"
```

Phép gán đứng một mình thì không bắt buộc quote, nhưng cứ quen tay quote sẵn. Thói quen đó cứu bạn về sau, khi đoạn code này bị bê vào làm tham số cho một hàm hay một lệnh.

### 5. Regex trong `[[ =~ ]]`

```sh
# ❌ trong bash, quote biến regex thành một chuỗi literal
[[ $email =~ "^[a-z]+@" ]]

# ✅ để regex trần, không quote
[[ $email =~ ^[a-z]+@ ]]

# ✅ hoặc bỏ vào biến rồi dùng biến không quote
regex='^[a-z]+@'
[[ $email =~ $regex ]]
```

## Khi nào thì bạn THẬT SỰ muốn word splitting

Vẫn có những lúc bỏ quote là đúng:

```sh
# Tách một chuỗi path phân cách bằng dấu hai chấm thành từng phần
IFS=: read -ra parts <<< "$PATH"
for p in "${parts[@]}"; do echo "$p"; done

# Ghép nhiều flag dòng lệnh lại — tách ra là có chủ đích
common_args="--verbose --color=always"
grep $common_args pattern file    # cố ý; nhớ thêm shellcheck disable=SC2086
```

Khi cố ý làm vậy, hãy thêm comment `# shellcheck disable=SC2086` kèm lý do. Vừa để shellcheck khỏi báo, vừa nói cho người đọc sau biết đây là chủ đích chứ không phải sơ suất.

## Gói lại trong một đoạn

Mỗi `$var` không quote là một lời mời shell đem chuỗi đi cắt theo khoảng trắng và bung glob. Đó hiếm khi là điều bạn muốn, và nó tạo ra loại bug chỉ nổ với vài input cụ thể — khó lần ra. Vậy nên: mặc định `"$var"`, mặc định `"${arr[@]}"`, viết bash thì ưu tiên `[[ ]]` hơn `[ ]`, và khi cố tình phá luật thì để lại `# shellcheck disable=SC2086` kèm lời giải thích.

## Tham chiếu chéo

- [learn/01-basics](../../../learn/01-basics/vi/notes.md) — nơi lần đầu chạm tới quoting.
- [topics/shellcheck](../../shellcheck/vi/README.md) — SC2086 sẽ tự bắt các biến quên quote.
- [cheatsheets/test.md](../../../cheatsheets/test.md) — so sánh nhanh `[ ]` và `[[ ]]`.
