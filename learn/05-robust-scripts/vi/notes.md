# 05 · Script chắc chắn — `set -euo pipefail`, IFS, error handling

## Mục tiêu

Sau bài này bạn sẽ:

- Viết script fail rõ ràng thay vì âm thầm làm hỏng dữ liệu.
- Hiểu chính xác `set -e`, `-u`, `-o pipefail` làm gì — và các bẫy đi kèm.
- Trap error và in diagnostic hữu ích.
- Validate input tại biên.

## 1. Header strict-mode

Mở đầu mọi script:

```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

- `-e` — thoát khi lỗi (bất kỳ lệnh nào trả non-zero → dừng script).
- `-u` — biến chưa set = lỗi.
- `-o pipefail` — pipeline fail nếu **bất kỳ** stage nào fail, không chỉ stage cuối.
- `IFS=$'\n\t'` — chỉ split theo newline và tab, không split theo space. Giảm bất ngờ từ expansion không quote.

## 2. Bẫy `set -e`

`set -e` hữu ích nhưng không phải phép màu. Nó **không** trigger khi:

```sh
# Trong điều kiện if/while/until
if broken_cmd; then ...           # broken_cmd fail ở đây là bình thường

# Bên trái && hoặc ||
broken_cmd && next                # broken_cmd fail âm thầm

# Trong function gọi qua $() mà caller chỉ check $()
```

Đừng dựa vào `set -e` cho check quan trọng. Dùng `|| { ... }` hoặc `if` tường minh.

## 3. `set -u` và default

```sh
echo "$name"                # lỗi nếu chưa set
echo "${name:-default}"     # dùng default nếu chưa set (không trigger -u)
echo "${name:?must be set}" # exit với message nếu chưa set
```

Guard sớm:
```sh
: "${API_URL:?}" "${API_KEY:?}"
```

## 4. `set -o pipefail`

```sh
grep foo huge.log | head -1     # không pipefail: exit 0 dù grep chết
```
Có `pipefail`, nếu `grep` chết (ví dụ file thiếu), cả pipeline exit non-zero. Đây gần như luôn là điều bạn muốn.

## 5. `trap ERR` — xem cái gì chết

```sh
trap 'echo "ERR at line $LINENO: $BASH_COMMAND" >&2' ERR
```

In lệnh fail và số dòng. Rẻ, vô cùng có ích khi debug.

## 6. Validate input

Script tồi tin input. Script tốt fail sớm ở biên.

```sh
usage() { echo "Usage: $0 <input> <output>" >&2; exit 2; }

[[ $# -eq 2 ]] || usage
input=$1
output=$2

[[ -r $input ]]  || { echo "không đọc được $input" >&2; exit 1; }
[[ ! -e $output || -w $output ]] || { echo "không ghi được $output" >&2; exit 1; }
```

## 7. Atomic write

Đừng ghi thẳng vào destination — ghi vào file tạm rồi `mv` cuối cùng. `mv` cùng filesystem là atomic.

```sh
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

produce_output > "$tmp"
mv "$tmp" "$destination"
trap - EXIT     # huỷ cleanup — file đã ở đúng chỗ
```

## 8. Template đầy đủ

```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

: "${API_URL:?}"

trap 'echo "ERR at line $LINENO: $BASH_COMMAND" >&2' ERR

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

usage() { echo "Usage: $0 ..." >&2; exit 2; }
[[ $# -ge 1 ]] || usage

# ... phần việc thật ...
```

## Đọc thêm

- [topics/debugging](../../../topics/debugging/vi/README.md)
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
