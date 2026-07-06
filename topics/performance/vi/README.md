# Topic · Performance

> 🌐 [English](../en/README.md) · **Tiếng Việt**

Shell nhanh khi làm "chất keo" nối các công cụ lại, nhưng chậm khi phải tự tính toán. Biết mình đang đứng ở phía nào của lằn ranh đó sẽ quyết định "viết bằng shell" có phải lựa chọn đúng hay không.

Điều đáng giá nhất trên trang này chỉ gói trong một câu: **fork rất đắt.** Khi câu đó ngấm, mọi thứ còn lại tự khắc suy ra được.

## Mô hình để hình dung

Mỗi lệnh không phải builtin của bash đều tốn khoảng 1–3 ms cho việc fork + exec trên Linux. Nghe nhỏ nhặt? Một vòng lặp gọi `sed` cho 10.000 dòng vừa trả tới 10.000 × 3 ms = **30 giây** chỉ để tạo tiến trình — chưa làm gì có ích cả.

Cũng 10.000 dòng đó, nếu đưa qua một lần gọi `sed` duy nhất, tổng cộng chỉ mất vài trăm **mili-giây**, vì chỉ fork đúng một lần rồi cho dữ liệu chảy qua.

## Bảng ước lượng bậc độ lớn

Con số áng chừng trên một laptop hiện đại, bỏ qua ảnh hưởng của cache:

| Thao tác | Thời gian mỗi lần |
|---|---|
| Builtin của bash (`[[`, `echo`, tính số, parameter expansion) | ~1 µs |
| Fork + exec một binary nhỏ (`ls`, `grep`, `sed`) | 1–3 ms |
| Fork + exec trình thông dịch Python | 30–80 ms |
| Fork + exec Node.js | 80–200 ms |
| Một dòng chảy qua pipeline đang chạy sẵn | Phụ thuộc I/O |

Quy tắc bỏ túi: **vòng lặp mà spawn từ 100 tiến trình trở lên thì nên refactor.** Dưới 100, hãy lo về tính đúng chứ đừng lo tốc độ.

## Những cách tối ưu rẻ tiền

### 1. Thay vòng lặp bằng `awk`, `sed`, hoặc `grep`

Ca kinh điển:

```sh
# ❌ 10.000 tiến trình cho một file 10.000 dòng
while IFS= read -r line; do
    echo "$line" | sed 's/foo/bar/'
done < file

# ✅ chỉ 1 tiến trình
sed 's/foo/bar/' file
```

`awk` / `sed` / `grep` đều đọc cả luồng dữ liệu trong một tiến trình duy nhất. Kể cả logic khá phức tạp cũng thường nhét vừa vào đó.

### 2. Dùng thao tác chuỗi builtin thay cho `basename`/`dirname`/`cut`

```sh
# ❌ 1 tiến trình mỗi vòng lặp
name=$(basename "$path")

# ✅ 0 tiến trình
name=${path##*/}
```

Parameter expansion là builtin của bash, không tốn fork. Xem [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md).

### 3. Bỏ `cat` thừa

```sh
cat file | grep foo         # ❌ fork thừa một cái
grep foo file               # ✅
grep foo < file             # ✅
```

"Useless use of cat" (dùng cat vô ích) là một câu đùa có thật trong giới. Không chỉ là chuyện đẹp mắt — mỗi `cat` thừa là một lần fork thừa.

### 4. Gom lệnh lại với `find ... -exec {} +`

```sh
# ❌ 1000 tiến trình rm
find . -name '*.tmp' -exec rm {} \;

# ✅ 1 tiến trình rm (hoặc vài cái, theo lô)
find . -name '*.tmp' -exec rm {} +
find . -name '*.tmp' -print0 | xargs -0 rm
```

Dạng `+` (khác với `\;`) của `-exec` sẽ gom tham số cho tới sát giới hạn độ dài dòng lệnh, nhờ đó giảm mạnh số lần fork.

### 5. Chạy song song những việc độc lập

`xargs -P N` chạy tối đa N lệnh cùng lúc:

```sh
# 8 tiến trình curl chạy đồng thời, mỗi URL một cái, đọc từ urls.txt
xargs -P8 -n1 -I{} curl -sI {} < urls.txt
```

Hoặc dùng background job cùng `wait`:

```sh
for host in a b c d; do
    ping -c1 "$host" &
done
wait
```

Xem [`learn/04-io-and-processes`](../../../learn/04-io-and-processes/vi/notes.md) để có mẫu đầy đủ.

### 6. Đừng tạo subshell khi không cần

Mỗi `( ... )` và `$(...)` đều là một subshell — tức một lần fork. Có lúc đáng (cô lập `cd`, bắt output), nhưng nhiều lúc thừa (`echo "$(echo hi)"` thực ra chỉ là `echo hi`).

## Đo trước, tối ưu sau

### Thời gian tổng

```sh
time ./slow.sh
```

### Đo từng đoạn

```sh
t0=$SECONDS
big_thing
echo "big_thing took $((SECONDS - t0))s" >&2

t0=$SECONDS
another_thing
echo "another_thing took $((SECONDS - t0))s" >&2
```

`$SECONDS` là builtin của bash, đếm số giây kể từ lúc shell khởi động. Lấy mẫu rất rẻ.

### Benchmark cho nghiêm túc

Khi cần so sánh chính xác, dùng [hyperfine](https://github.com/sharkdp/hyperfine):

```sh
hyperfine --warmup 3 './old.sh' './new.sh'
```

Nó chạy mỗi lệnh nhiều lần, loại các lần warm-up (để cache ổn định), rồi báo trung bình ± độ lệch chuẩn kèm mức ý nghĩa thống kê.

## Những anti-pattern cần bỏ

| Anti-pattern | Cái giá | Cách sửa |
|---|---|---|
| `for f in $(ls *.log)` | 1 tiến trình, kèm bug word-split | `for f in *.log` |
| `cat file \| grep foo` | thừa 1 fork | `grep foo file` |
| `basename "$p"` trong vòng lặp | N fork | `${p##*/}` |
| `echo "$x" \| tr A-Z a-z` | N fork | `${x,,}` (bash 4+) |
| `sed 's/x/y/' <<< "$var"` | 1 fork | `${var/x/y}` |
| Ngồi `sleep` để chờ một file xuất hiện | phí mấy giây vô ích | `inotifywait`, hoặc poll bằng `[[ -e ]]` |

## Khi nào nên rời khỏi shell

Bạn đã vượt tầm của shell khi:

- Dữ liệu lớn hơn vài trăm MB mà bạn lại xử lý từng dòng.
- Bạn cần cấu trúc dữ liệu thật sự (map chứa array chứa record).
- Nút thắt nằm ở CPU (regex trên chuỗi khổng lồ, tính toán, sắp xếp khối dữ liệu lớn).
- Bạn phải làm việc với số thực (bash chỉ có số nguyên).

Đến lúc đó:

- **`awk`** là nâng cấp tự nhiên đầu tiên — vẫn mô hình "một tiến trình, dữ liệu chảy qua" nhưng có biến và array thật.
- **Python** là bước hai — kiểu dữ liệu đầy đủ, có exception, thư viện chuẩn khổng lồ. `subprocess` giúp bạn vẫn shell-out được cho những việc shell làm tốt.
- **Go** hoặc **Rust** là bước ba — khi thời gian khởi động quan trọng và bạn muốn xuất ra một binary duy nhất.

Kỹ năng ở đây không phải là cố bám lấy shell, mà là biết khi nào nên buông.

## Tham chiếu chéo

- [learn/06-advanced](../../../learn/06-advanced/vi/notes.md) — parameter expansion (thao tác chuỗi không tốn fork).
- [learn/04-io-and-processes](../../../learn/04-io-and-processes/vi/notes.md) — `xargs -P`, background job.
- [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md) — mọi thao tác chuỗi mà nếu không có nó bạn sẽ phải fork.
