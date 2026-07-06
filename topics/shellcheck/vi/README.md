# Topic · shellcheck

> 🌐 [English](../en/README.md) · **Tiếng Việt**

`shellcheck` là công cụ phân tích tĩnh cho shell script — nó đọc code của bạn và chỉ ra lỗi mà không cần chạy. Nó bắt được phần lớn những sai lầm mà cả repo này đang cố dạy bạn tránh, ngay khi bạn vừa gõ xong.

Nếu chỉ cài đúng một công cụ trong toàn bộ repo này, hãy cài `shellcheck`.

## Vì sao nên dùng

Thông báo lỗi của bash nổi tiếng là "trời ơi đất hỡi". Ví dụ:

```sh
$ ./script.sh
./script.sh: line 12: syntax error near unexpected token `done'
```

Chỉ vậy thôi, không nói rõ thực sự sai ở đâu. Trong khi đó `shellcheck` cho bạn:

```sh
$ shellcheck script.sh

In script.sh line 8:
    if [ $count -gt 0 ]
       ^-- SC1073 (error): Couldn't parse this test expression.
                          Fix to allow more checks.

In script.sh line 8:
    if [ $count -gt 0 ]
                       ^-- SC1009 (error): The mentioned syntax error was in this if expression.
```

Nó chỉ đúng ký tự có vấn đề, giải thích mã lỗi, và kèm link tới trang wiki hướng dẫn sửa. Có thể xem mỗi cảnh báo của nó như một bài học kinh nghiệm về shell đã được đúc kết sẵn.

## Cài đặt

```sh
brew install shellcheck                     # macOS
sudo apt install shellcheck                 # Debian/Ubuntu
sudo pacman -S shellcheck                   # Arch
```

Kiểm tra:
```sh
shellcheck --version
```

Hoặc thử ngay trên trình duyệt: https://www.shellcheck.net/

## Dùng cơ bản

```sh
shellcheck script.sh                        # quét một file
shellcheck script1.sh script2.sh            # nhiều file
shellcheck -x script.sh                     # đi theo các lệnh `source` và `.`
shellcheck --severity=warning script.sh     # bỏ qua các góp ý cấp style
shellcheck --shell=bash script.sh           # chỉ định dialect (bash/sh/dash/ksh)
```

Các mức nghiêm trọng, từ gắt nhất tới nhẹ nhất:

- `error` — code gần như chắc chắn hỏng.
- `warning` — rất nhiều khả năng là bug. **Đây là mức chuẩn của repo này.**
- `info` — có thể là bug, tùy ý định của bạn.
- `style` — góp ý nhỏ nhặt; bỏ qua được, trừ khi team bạn bắt buộc.

Chọn mức nào thì mọi thứ từ mức đó trở lên sẽ được báo.

## Tích hợp vào editor

Được gạch chân lỗi ngay lúc gõ thì hơn hẳn chạy kiểm tra theo mẻ. Cài một lần rồi quên đi:

- **VS Code**: cài `timonwong.shellcheck`. Chỉ cần `shellcheck` có trong `$PATH` là chạy được ngay.
- **Neovim**: dùng `nvim-lspconfig` với `bashls` — `bashls` gọi `shellcheck` bên dưới.
- **Vim**: dùng ALE (`w0rp/ale`) với `let g:ale_linters = {'sh': ['shellcheck']}`.
- **JetBrains**: có sẵn. Vào Settings → Editor → Inspections → Shell Script → bật shellcheck.
- **Sublime Text**: cài package `SublimeLinter-shellcheck`.

## Tích hợp vào CI

File [`.github/workflows/build.yml`](../../../.github/workflows/build.yml) của repo này chạy `shellcheck` mỗi lần push. Bạn có thể bê nguyên mẫu:

```yaml
- name: Install shellcheck
  run: sudo apt-get install -y shellcheck
- name: Run shellcheck
  run: find . -name '*.sh' -exec shellcheck --severity=warning {} +
```

Xem thêm [`tools/lint-all.sh`](../../../tools/lint-all.sh) để có một script chạy độc lập.

## Tắt cảnh báo (đúng cách)

Chỉ tắt khi bạn thực sự hiểu lý do. Đừng bao giờ tắt bừa cả loạt.

**Tắt theo dòng, kèm lý do:**
```sh
# shellcheck disable=SC2086  # cố ý không quote để kích hoạt word splitting
run $args
```

**Tắt theo cả file (đặt ở đầu file):**
```sh
#!/usr/bin/env bash
# shellcheck disable=SC1091
```

**Tắt toàn repo:** tạo file `.shellcheckrc`:
```
disable=SC1091
```

Nên ưu tiên comment theo dòng. Một directive tắt cảnh báo mà không kèm lý do là dấu hiệu đáng ngờ — người đọc sau không hiểu vì sao nó ở đó. Nếu một directive tồn tại hàng tháng mà chẳng ai sửa, hãy coi đó là lỗi thiết kế: khả năng cao shellcheck đã đúng ngay từ đầu.

## 10 cảnh báo bạn sẽ gặp nhiều nhất

| Mã | Ý nghĩa | Cách sửa thường dùng |
|---|---|---|
| SC2086 | Biến không quote → bị word split | `"$var"` |
| SC2068 | `$@`/`${arr[@]}` không quote | `"$@"` / `"${arr[@]}"` |
| SC2155 | `local x=$(cmd)` che mất exit code của cmd | Tách ra: `local x; x=$(cmd)` |
| SC2164 | `cd` không kiểm tra kết quả | `cd foo \|\| exit` |
| SC1091 | Không lần theo được `source` | `# shellcheck source=./lib.sh` |
| SC2015 | `A && B \|\| C` không phải if/else | Viết `if`/`then`/`else` cho đàng hoàng |
| SC2181 | Kiểm tra `$?` ngay sau một lệnh | Dùng `if cmd; then ...` |
| SC2046 | `$(...)` không quote | `"$(...)"` |
| SC2001 | Dùng sed cho việc mà parameter expansion làm được | `${var/old/new}` |
| SC2001 (nữa) | Xem trên | Cùng cách sửa |

Wiki đầy đủ, mỗi mã một trang: https://www.shellcheck.net/wiki/

## Một ví dụ trọn vẹn

Trước:
```sh
#!/bin/bash
count=`ls *.log | wc -l`
if [ $count -gt 5 ]; then
    for f in $(ls *.log); do
        cat $f
    done
fi
```

`shellcheck` sẽ nói (tóm ý):

- SC2006 — dùng `$(...)` thay cho backtick.
- SC2086 — quote `$count` trong phần test.
- SC2045 — đừng lặp qua output của `ls`.
- SC2086 — quote `$f`.

Sau:
```sh
#!/usr/bin/env bash
set -euo pipefail

count=$(find . -maxdepth 1 -name '*.log' | wc -l)
if [[ $count -gt 5 ]]; then
    for f in *.log; do
        cat "$f"
    done
fi
```

Gọn hơn, an toàn hơn, và sạch lỗi shellcheck. Vòng lặp là: viết → lint → sửa → lặp lại. Vài tuần sau, các phản xạ tốt sẽ ngấm vào tay, và shellcheck chuyển vai từ "ông thầy" thành "lưới an toàn".

## Tham chiếu chéo

- [tools/lint-all.sh](../../../tools/lint-all.sh) — script lint cho cả repo.
- [topics/quoting](../../quoting/vi/README.md) — bản chất của phần lớn cảnh báo shellcheck.
