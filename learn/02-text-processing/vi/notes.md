# 02 · Xử lý text — grep, sed, awk, cut, sort, uniq

## Mục tiêu

Sau bài này bạn sẽ:

- Tìm text bằng `grep` (basic vs extended regex, flag hay dùng).
- Biến đổi stream bằng `sed` (thay thế, xoá, chọn range dòng).
- Cắt dữ liệu dạng bảng bằng `cut`, dạng tự do bằng `awk`.
- Sắp xếp và loại trùng bằng `sort` + `uniq`.
- Ghép chúng vào 1 pipeline thay vì viết script.

Kinh nghiệm: giải được bằng 1 pipeline thì đừng viết script. Khi pipeline có 3 lệnh `awk` thì đến lúc viết script.

## 1. `grep` — tìm

```sh
grep 'pattern' file          # dòng khớp
grep -i 'error' log          # không phân biệt hoa thường
grep -v 'DEBUG' log          # đảo ngược
grep -n 'todo' *.md          # hiện số dòng
grep -r 'foo' src/           # đệ quy
grep -c 'ERROR' log          # đếm
grep -l 'password' -r .      # liệt kê file chứa match
grep -E 'foo|bar' file       # extended regex (or)
grep -oE '[0-9]+'            # chỉ in phần khớp
grep -A 2 -B 1 'panic'       # 2 dòng sau, 1 dòng trước
```

Ưu tiên `grep -E` — basic regex phải escape `(`, `)`, `|`, `+`, `?`.

## 2. `sed` — stream editor

```sh
sed 's/old/new/' file        # thay match đầu mỗi dòng
sed 's/old/new/g' file       # thay hết
sed -i 's/foo/bar/g' file    # sửa in-place (GNU); macOS: sed -i '' 's/.../.../g'
sed -n '5,10p' file          # in dòng 5–10
sed '/^#/d' file             # xoá dòng bắt đầu bằng #
sed 's|/old/path|/new/path|' # dùng | làm delimiter khi replace path
sed -E 's/([0-9]+)/[\1]/g'   # capture group
```

macOS `sed` (BSD) và GNU `sed` khác nhau. In-place portable: `sed -i.bak 's/.../.../g' file && rm file.bak`.

## 3. `awk` — xử lý theo cột

Mỗi dòng chia thành field theo whitespace: `$1`, `$2`, ..., `$NF` (cuối), `$0` (cả dòng).

```sh
awk '{print $2}' file                  # cột 2
awk -F, '{print $1}' file.csv          # đổi separator
awk 'NR==5' file                       # chỉ dòng 5
awk 'length($0) > 80' file             # dòng dài hơn 80 ký tự
awk '/ERROR/ {print $1, $NF}' log      # pattern + action
awk '{sum+=$1} END {print sum}' nums   # cộng dồn
awk 'NR==FNR{a[$1]=1; next} $1 in a' A B  # join: giữ dòng B có $1 nằm trong A
```

`awk` là ngôn ngữ nhỏ. Khi cần 3 điều kiện + 2 mảng thì chuyển sang script — nhưng trước đó, awk nhanh và portable.

## 4. `cut`, `sort`, `uniq`, `tr`, `wc`

```sh
cut -d, -f1,3 file.csv       # cột 1 và 3, delimiter ,
cut -c1-10 file              # ký tự 1–10

sort file                    # lexicographic
sort -n file                 # số
sort -k2,2 file              # sort theo field 2
sort -u file                 # sort + dedup
sort -t, -k3,3n -k1,1 f.csv  # nhiều key

uniq file                    # bỏ trùng LIỀN KỀ (nhớ sort trước!)
uniq -c file                 # prefix bằng count
sort file | uniq -c | sort -rn   # bảng tần suất

tr 'a-z' 'A-Z' < file        # chữ hoa
tr -d '\r' < win.txt         # xoá CR
tr -s ' '                    # gộp nhiều space thành 1

wc -l file                   # đếm dòng
wc -c file                   # bytes
```

Hãy xem `cut -d,` và `awk -F,` là tool cho text phân tách bằng dấu phẩy đơn giản, không phải parser CSV chuẩn RFC. Khi field có thể chứa dấu phẩy trong ngoặc kép, dấu `"` thật, hoặc newline bên trong, hãy chuyển sang CSV parser đúng nghĩa.

## 5. Pipeline thực tế

"Top 10 IP theo số request trong access log":

```sh
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

5 tầng, không cần file tạm, streaming từng dòng — memory không thành vấn đề.

## Đọc thêm

- [cheatsheets/grep.md](../../../cheatsheets/grep.md)
- [cheatsheets/sed.md](../../../cheatsheets/sed.md)
- [cheatsheets/awk.md](../../../cheatsheets/awk.md)
- `man grep`, `man sed`, `man awk`.
