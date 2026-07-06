# 03 · Nền tảng scripting — biến, if, loop, function, exit code

## Mục tiêu

Sau bài này bạn sẽ:

- Khai báo biến đúng (local vs global, quote khi gán).
- Viết `if`, `case`, `for`, `while` — biết khi nào dùng cái nào.
- Viết function có biến local và return code đúng.
- Đọc exit code, dùng `&&`/`||` cho control flow.
- Đọc argument và xử lý flag bằng `getopts`.

## 1. Biến

```sh
name=alice              # KHÔNG có space quanh dấu =
name="Alice Smith"      # quote khi string có space
count=$((1 + 2))        # số học
today=$(date +%F)       # command substitution
readonly VERSION=1.0    # không thể gán lại
unset name              # xoá
```

Chỉ `export` khi child process cần đọc. Còn lại giữ local cho script.

```sh
export PATH="$HOME/bin:$PATH"    # child kế thừa
tmp="$(mktemp)"                  # local, không export
```

Giá trị mặc định:

```sh
name="${1:-world}"          # dùng $1, nếu không có thì "world"
: "${API_URL:?must be set}" # thoát nếu chưa set (guard đầu script)
```

## 2. `if` và `[[ ]]`

```sh
if [[ -f "$file" ]]; then
    echo "file tồn tại"
elif [[ -d "$file" ]]; then
    echo "là thư mục"
else
    echo "không có"
fi
```

Ưu tiên `[[ ]]` trong bash — an toàn hơn `[ ]` (không word-split bên trong, hỗ trợ `&&`/`||`, pattern match với `==` và regex với `=~`).

Các test hay dùng:

| Test | Ý nghĩa |
|---|---|
| `-f file` | file thường |
| `-d file` | thư mục |
| `-e file` | tồn tại |
| `-r/-w/-x file` | đọc/ghi/thực thi |
| `-z str` | chuỗi rỗng |
| `-n str` | chuỗi không rỗng |
| `str1 == str2` | bằng |
| `str =~ regex` | khớp regex (bash) |
| `n -eq/-ne/-lt/-gt` | so sánh số nguyên |

## 3. `case`

```sh
case "$1" in
    start)  systemctl start app ;;
    stop)   systemctl stop app ;;
    reload) systemctl reload app ;;
    *)      echo "unknown"; exit 2 ;;
esac
```

Gọn hơn chuỗi `elif` khi so sánh với string cố định hoặc glob pattern.

## 4. Loop

```sh
for f in *.log; do
    gzip "$f"
done

for i in {1..5}; do
    echo "$i"
done

for i in $(seq 1 5); do        # phổ biến, nhưng không phải POSIX
    echo "$i"
done

while read -r line; do
    process "$line"
done < input.txt

while true; do
    check_something && break
    sleep 5
done
```

Đọc file từng dòng: **luôn** dùng `while read -r`, đừng `for line in $(cat file)` — cái sau word-split và glob-expand.

`seq` có mặt ở rất nhiều hệ, nhưng nó không phải utility bắt buộc của POSIX. Nếu bạn cần portability cao, hãy ưu tiên `while` loop với biến đếm số nguyên.

## 5. Function

```sh
say_hello() {
    local name=${1:-world}
    echo "hello, $name"
}

say_hello alice
```

Nguyên tắc:
- Argument phải khai `local` bên trong — không thì rò rỉ ra scope caller.
- Trả giá trị qua `echo` (bắt bằng `$(...)`) hoặc exit code với `return 0..255`.
- Đừng `exit` trong function dùng để trả giá trị — sẽ giết cả script.

## 6. Exit code và control flow

```sh
cmd && echo "ok"          # chạy vế 2 nếu vế 1 thành công (exit 0)
cmd || echo "failed"      # chạy vế 2 nếu vế 1 fail
cmd1 && cmd2 || cmd3      # cẩn thận: cmd3 chạy nếu cmd1 HOẶC cmd2 fail
```

Convention exit code:
- `0` = thành công.
- `1` = lỗi chung.
- `2` = misuse (argument sai).
- `126`, `127`, `130` = reserved (permission, not found, Ctrl-C).

Đọc exit code gần nhất bằng `$?` (chỉ ngay sau — lệnh tiếp theo sẽ overwrite).

## 7. `getopts` — parse flag

```sh
usage() { echo "Usage: $0 [-v] [-o file] input" >&2; exit 2; }

verbose=0
output=/dev/stdout
while getopts ":vo:h" opt; do
    case $opt in
        v) verbose=1 ;;
        o) output=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ge 1 ]] || usage
input=$1
```

`getopts` có sẵn trong bash — không cần dependency. Đủ dùng 90% script. Cho long option (`--verbose`), viết parser tay (xem [snippets/argparse.sh](../../../snippets/argparse.sh)).

## Đọc thêm

- [topics/quoting](../../../topics/quoting/vi/README.md)
- [snippets/getopts.sh](../../../snippets/getopts.sh)
