# 01 · Basics — điều hướng, pipes, redirect, quoting

## Mục tiêu

Sau bài này bạn sẽ:

- Di chuyển và khảo sát filesystem không cần mò mẫm.
- Hiểu 3 luồng chuẩn (stdin/stdout/stderr) và ghép chúng bằng pipe/redirect.
- Biết quote đúng — nguồn bug shell #1.

## 1. Điều hướng

```sh
pwd                    # đang ở đâu
cd -                   # về thư mục trước đó
cd                     # về $HOME
ls -lah                # long, all, human-readable
```

## 2. Ba luồng chuẩn

| FD | Tên | Mặc định |
|----|-----|----------|
| 0 | stdin | bàn phím |
| 1 | stdout | terminal |
| 2 | stderr | terminal |

```sh
cmd > out.txt          # stdout → file (ghi đè)
cmd >> out.txt         # stdout → file (append)
cmd 2> err.txt         # stderr → file
cmd > out 2>&1         # gộp cả 2 vào out
cmd &> out             # bash shortcut cho lệnh trên
cmd < in.txt           # đọc stdin từ file
```

Bẫy kinh điển: `cmd 2>&1 > out` **không** gộp stderr vào file — thứ tự đọc từ trái sang phải, lúc `2>&1` thì stdout vẫn là terminal. Đúng: `cmd > out 2>&1`.

## 3. Pipe

```sh
ps aux | grep nginx | awk '{print $2}'
```

Pipe nối stdout của lệnh trái vào stdin của lệnh phải. Mỗi lệnh chạy trong **subshell riêng** — biến gán trong pipe không tồn tại sau đó (bài 04).

## 4. Quoting — phần quan trọng nhất bài này

| Kiểu | Ví dụ | Expand biến? | Expand `$(...)`? | Giữ khoảng trắng? |
|---|---|---|---|---|
| không quote | `$var` | ✅ | ✅ | ❌ (word split) |
| nháy đơn `'...'` | `'$var'` | ❌ | ❌ | ✅ |
| nháy kép `"..."` | `"$var"` | ✅ | ✅ | ✅ |

**Quy tắc vàng**: luôn `"$var"` trừ khi bạn cố tình muốn word-splitting.

```sh
file="my file.txt"
rm $file           # ❌ chạy `rm my file.txt` → xoá 2 file
rm "$file"         # ✅
```

## 5. Globbing

```sh
ls *.md            # mọi file .md ở cwd
ls **/*.md         # đệ quy (cần `shopt -s globstar` với bash)
ls file?.txt       # 1 ký tự bất kỳ
ls [ab]*.txt       # bắt đầu bằng a hoặc b
```

Glob chạy ở tầng shell **trước khi** lệnh nhận argument. Nếu không match, bash mặc định để nguyên literal (bẫy!) — bật `shopt -s failglob` để báo lỗi thay vì để nguyên.

## Đọc thêm

- [topics/quoting](../../../topics/quoting/README.md) — sâu hơn về `$IFS` và word splitting.
- `man bash` mục `REDIRECTION`.
