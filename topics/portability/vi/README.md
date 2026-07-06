# Topic · Portability — bash vs POSIX sh vs BSD tools

> 🌐 [English](../en/README.md) · **Tiếng Việt**

Tính khả chuyển (portability) không phải là "đức tính" để theo đuổi bằng mọi giá. Nó là cái giá bạn trả để đổi lấy một lợi ích cụ thể: script chạy y nguyên trên container Alpine, router BusyBox, bản bash cổ lỗ của macOS, hay mấy server cũ không thể nâng cấp. Nếu bạn không cần những nơi đó, đừng trả cái giá này.

Trang này giúp bạn quyết định trước, rồi mới đi vào những khác biệt cụ thể khi đã chọn xong.

## Chọn mục tiêu TRƯỚC khi viết

Ba tầng, từ ít khả chuyển đến khả chuyển nhất:

### Tầng 1 — bash 4+ (`#!/usr/bin/env bash`)

Bạn có đủ đồ chơi: array, associative array, `[[ ]]`, `${var/a/b}`, process substitution, `local -n`, `mapfile`, `${var,,}`. Chạy trên mọi bản Linux, và chạy trên macOS nếu người dùng đã cài bash mới (`brew install bash`).

**Chọn tầng này khi**: script cá nhân, công cụ nội bộ của team, Docker image có `RUN apt install bash`.

### Tầng 2 — bash 3.2 (`#!/bin/bash`)

Bản mặc định của macOS (đóng băng từ 2007). Không associative array, không `mapfile`, không `${var,,}`, không `local -n`. Nhưng vẫn còn array, `[[ ]]`, và process substitution.

**Chọn tầng này khi**: script cần chạy được ngay trên macOS chưa cài thêm gì.

### Tầng 3 — POSIX sh (`#!/bin/sh`)

Chạy ở khắp nơi. Không array, không `[[ ]]`, không process substitution, không `local` (theo nghĩa chặt). Trên Alpine thì `sh` là BusyBox `ash`, trên Debian là `dash`, còn trên macOS thực ra là bash chạy ở chế độ POSIX.

**Chọn tầng này khi**: script cài đặt phát qua `curl | sh`, script init dịch vụ trên Alpine, hệ thống nhúng.

**Cái bẫy kinh điển**: viết bằng cú pháp bash nhưng shebang lại để `#!/bin/sh`. Trên máy bạn nó chạy ngon (vì `sh` của bạn thật ra là bash), nhưng lên Alpine là toang (vì `ash` không hiểu `[[ ]]`). Chạy `shellcheck --shell=sh` để bắt lỗi này sớm.

## bash vs POSIX sh — những khác biệt hay dùng nhất

| Bash | Tương đương POSIX |
|---|---|
| `[[ x == y ]]` | `[ "$x" = "$y" ]` |
| `[[ $s =~ regex ]]` | `case "$s" in pattern) ... esac` hoặc `expr` |
| `arr=(a b)` | (không có — dùng tham số vị trí hoặc chuỗi ngăn bằng newline) |
| `${arr[@]}` | (không có) |
| `${var,,}` (viết thường) | `echo "$var" \| tr A-Z a-z` |
| `${var:0:3}` (cắt chuỗi con) | `echo "$var" \| cut -c1-3` hoặc `expr substr` |
| `$((x++))` | `x=$((x + 1))` |
| `<(cmd)` process substitution | Dùng file tạm |
| `read -r -a arr` | (không có) |
| `local x` trong hàm | Không hẳn thuộc POSIX; nhưng dash/ash/bash đều hỗ trợ trên thực tế |
| `echo -e "\t"` | `printf '\t'` |
| `${!var}` (tham chiếu gián tiếp) | `eval` (đúng vậy, `eval`) |

**Điều rút ra**: gần như luôn tồn tại một bản POSIX tương đương, nhưng nó xấu hơn và thường phải fork thêm một tiến trình phụ (`tr`, `cut`, `expr`). Đó chính là cái giá thật của Tầng 3.

## bash 4 vs bash 3.2 (macOS)

Những tính năng "đáng tiền" bạn mất trên bash mặc định của macOS:

- Associative array (`declare -A`).
- `mapfile` / `readarray`.
- `${var,,}`, `${var^^}` (đổi hoa/thường).
- `${!prefix*}` (liệt kê tên biến theo tiền tố).
- `local -n` nameref (bản 4.0–4.2 cũng chưa có).

Nếu muốn script Chạy-Là-Được trên macOS chưa chỉnh sửa, hãy tránh những cái trên. Còn không thì `brew install bash` và ghi rõ yêu cầu "bash 4+" trong phần điều kiện tiên quyết.

## Khác biệt công cụ thường gặp (BSD trên macOS vs GNU trên Linux)

### `sed -i` (sửa tại chỗ)

```sh
sed -i 's/x/y/' file          # GNU — chạy được
sed -i '' 's/x/y/' file       # BSD — cần thêm tham số ''
sed -i.bak 's/x/y/' file      # CẢ HAI — tạo file .bak, rồi tự xóa nó
```

Mẹo `.bak` là cách viết chạy được cả hai. Gần như mọi script sửa tại chỗ mà cần đa nền tảng đều dùng nó.

### Tính toán với `date`

```sh
# "Hôm qua" ở định dạng ISO:
date -d 'yesterday' +%F         # GNU
date -v-1d +%F                  # BSD
```

Cách tỉnh táo cho bất cứ việc gì phức tạp hơn: nhờ Python:
```sh
python3 -c 'from datetime import date, timedelta; print(date.today()-timedelta(days=1))'
```

### `readlink -f` (chuẩn hóa đường dẫn)

```sh
readlink -f "$path"             # GNU — resolve hết symlink
# readlink của BSD không có -f. Cách thay:
python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$path"

# Hoặc thuần shell:
cd -P -- "$(dirname -- "$path")" && printf '%s/%s\n' "$(pwd -P)" "$(basename -- "$path")"
```

### `grep -P` (Perl regex)

Chỉ GNU mới có. Khi được thì dùng `grep -E` (extended regex) — nó bao khoảng 95% nhu cầu Perl regex. Nếu thật sự cần PCRE, cài `pcregrep` hoặc viết bằng awk/Python.

### `stat`

```sh
stat -c '%s' file        # GNU: kích thước file
stat -f '%z' file        # BSD: kích thước file
```

Khác cả flag LẪN cách viết specifier. Cách chạy-cả-hai: dùng `wc -c < file` để lấy kích thước.

### `xargs -P` (song song)

Cả hai đều hỗ trợ. GNU có thêm `-r` (không làm gì khi input rỗng) mà BSD thiếu. Cách viết an toàn cho cả hai: `xargs -0 -I{}` phòng khi input có thể rỗng.

### `mktemp`

```sh
mktemp                          # cả hai, cho một đường dẫn file mới
mktemp -d                       # cả hai, tạo thư mục
mktemp /tmp/foo.XXXXXX          # cả hai, template tùy chỉnh
mktemp --tmpdir=/x foo.XXXXXX   # chỉ GNU
```

Cứ bám theo template và thư mục, tránh các flag riêng của GNU.

## Cách kiểm thử tính khả chuyển

Ba cách bổ trợ cho nhau:

### 1. Tĩnh — shellcheck

```sh
shellcheck --shell=sh script.sh          # cho mục tiêu POSIX
shellcheck --shell=bash script.sh        # cho mục tiêu bash
```

Bắt các "bashism" lọt vào script POSIX, và ngược lại.

### 2. Container — Alpine

Đẩy script vào một container Alpine xem có chạy không:
```sh
docker run --rm -v "$PWD:/app" alpine sh /app/script.sh
```

`sh` của Alpine là BusyBox `ash` — mục tiêu chung khắt khe nhất cho script POSIX. Chạy được ở đây thì gần như chạy được mọi nơi.

### 3. Cài song song GNU + BSD

Trên macOS:
```sh
brew install gnu-sed coreutils gnu-tar findutils
```

Chúng được cài dưới tên `gsed`, `gcp`, `gtar`, `gfind`. Test cả hai bên:
```sh
gsed --version
sed --version    # BSD
```

Nhờ vậy bạn viết được script chạy với cả hai và kiểm tra ngay lúc đang viết.

## Khuyến nghị thực dụng

- **Script dev trên máy bạn**: bash 4+. Đừng vẽ vời cho mệt.
- **Công cụ nội bộ của team**: bash 4+, ghi rõ yêu cầu trong README.
- **Docker image bạn tự bảo trì**: theo cái mà base image có sẵn. `apt install bash` trên Debian là ổn; trên Alpine thì hoặc cài bash, hoặc viết cho `ash`.
- **Installer hướng người dùng (`curl \| sh`)**: POSIX sh, test trên Alpine.
- **Thứ chạy trên server dùng chung**: kiểm tra `bash --version` trước, rồi viết cho bản thấp nhất.

## Tham chiếu chéo

- [shells/posix-sh](../../../shells/posix-sh/README.md) — các idiom POSIX.
- [shells/bash](../../../shells/bash/README.md) — chuyện phiên bản bash.
- [topics/shellcheck](../../shellcheck/vi/README.md) — flag `--shell=sh` giúp bắt bashism.
