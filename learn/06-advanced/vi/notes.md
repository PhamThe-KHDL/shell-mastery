# 06 · Nâng cao — array, associative array, parameter expansion, coproc

## Mục tiêu

Sau bài này bạn sẽ:

- Dùng array và associative array đúng.
- Xử lý chuỗi bằng parameter expansion (không cần `sed` cho việc thường).
- Hiểu `local -n` nameref để truyền array vào function.
- Biết khi nào cần `coproc` — và khi nào không.
- Đọc regex bằng `=~` và back-reference.

## 1. Array

```sh
files=(a.txt b.txt "c d.txt")
echo "${files[0]}"           # a.txt
echo "${files[@]}"           # a.txt b.txt c d.txt (mỗi phần tử = 1 arg)
echo "${#files[@]}"          # 3
files+=(e.txt)               # append
unset 'files[1]'             # xoá index 1 (để lại lỗ!)

# Duyệt
for f in "${files[@]}"; do echo "$f"; done

# Đọc file vào array (bash 4+):
mapfile -t lines < file.txt
readarray -t lines < file.txt    # alias

# Đọc từ lệnh
mapfile -t hosts < <(cut -d, -f1 hosts.csv)

# Slice
echo "${files[@]:1:2}"       # 2 phần tử bắt đầu từ index 1
```

Luôn quote `"${arr[@]}"` — không quote sẽ word-split và glob-expand.

## 2. Associative array (bash 4+)

```sh
declare -A user
user[name]=alice
user[email]=alice@example.com

echo "${user[name]}"
echo "${!user[@]}"           # keys
echo "${user[@]}"            # values

# Kiểm tra key tồn tại
[[ -v user[name] ]] && echo "có name"
```

macOS mặc định bash 3.2 — không có associative array. Cài bash 4+: `brew install bash`, rồi dùng `#!/usr/bin/env bash` (giả sử bash trên `$PATH` là bản mới).

## 3. Parameter expansion — xử lý chuỗi không cần sed

```sh
name="hello_world.tar.gz"

echo "${name%.gz}"           # hello_world.tar   (bỏ suffix match ngắn nhất)
echo "${name%%.*}"           # hello_world       (bỏ suffix match dài nhất từ . đầu)
echo "${name#hello_}"        # world.tar.gz      (bỏ prefix ngắn nhất)
echo "${name##*/}"           # tương đương basename
echo "${name%/*}"            # tương đương dirname

echo "${name/world/earth}"   # hello_earth.tar.gz  (thay lần đầu)
echo "${name//_/-}"          # hello-world.tar.gz  (thay hết)

echo "${#name}"              # độ dài
echo "${name:6:5}"           # substring: start=6, len=5

echo "${name:-default}"      # dùng default nếu unset/empty
echo "${name:=default}"      # gán default nếu unset/empty
echo "${name:+alt}"          # dùng "alt" NẾU name được set
echo "${name:?err}"          # lỗi nếu unset
```

Nhanh hơn spawn `sed`/`cut` trong loop.

## 4. Nameref — truyền array vào function

```sh
push() {
    local -n arr=$1        # arr giờ là reference đến array của caller
    shift
    arr+=("$@")
}

items=(a b)
push items c d e
declare -p items           # items=([0]="a" [1]="b" [2]="c" [3]="d" [4]="e")
```

Cần bash 4.3+. Trước nameref, người ta expand `"${arr[@]}"` rồi build lại bên trong — vụng, mất element rỗng.

## 5. Regex với `=~`

```sh
s="user@example.com"
if [[ $s =~ ^([^@]+)@(.+)$ ]]; then
    echo "user=${BASH_REMATCH[1]} host=${BASH_REMATCH[2]}"
fi
```

Đừng quote regex bên phải — quote sẽ biến thành literal trong bash.

## 6. `coproc` — child 2 chiều

```sh
coproc BC { bc; }
echo "1+1" >&"${BC[1]}"
read -r result <&"${BC[0]}"
echo "$result"
kill "$BC_PID"
```

Hiếm khi là công cụ đúng — thường pipe là đủ. Dùng `coproc` khi phải gửi nhiều input và đọc nhiều output từ cùng 1 process (công cụ interactive, protocol session-oriented). Ngoài ra, file tạm hoặc 2 pipe đơn giản hơn.

## 7. Khi nào rời shell

Bạn ra khỏi vùng thoải mái của shell khi:

- Có data structure lồng nhau (map của array của map).
- Cần error type hoặc exception đàng hoàng.
- Số học vượt integer.
- Perf quan trọng (loop hàng triệu item).

Lúc đó: Python, Go, hoặc ngôn ngữ đàng hoàng. `awk` vẫn lấp khoảng trống giữa shell và Python.

## Đọc thêm

- [cheatsheets/arrays.md](../../../cheatsheets/arrays.md)
- [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md)
