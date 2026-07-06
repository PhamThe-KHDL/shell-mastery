# Topic · Debugging shell scripts

> 🌐 [English](../en/README.md) · **Tiếng Việt**

Debug shell phần lớn là "in ra đúng thứ, vào đúng lúc", phần nhỏ còn lại là "mở manual đọc lại". Không có IDE, không breakpoint bấm nút — chỉ có trace (theo dõi từng bước) và suy nghĩ.

Mấy công cụ dưới đây miễn phí và học trong một phút. Cứ học hết, vì mỗi cái hợp với một kiểu tình huống khác nhau.

## Tư duy khi debug

Trước khi động vào công cụ nào, tự hỏi ba câu:

1. **Mình mong đợi điều gì?** Nói thành lời, gọn trong một câu.
2. **Thực tế xảy ra gì?** Đọc kỹ output, đừng lướt qua.
3. **Thay đổi nhỏ nhất nào đủ để chỉ ra chỗ hai cái đó lệch nhau?**

In ra để biết chắc, đừng ngồi đoán. Bash trả công cho người kiên nhẫn.

## 1. `bash -n` — kiểm cú pháp mà không chạy

```sh
bash -n script.sh
```

Chỉ chạy phần phân tích cú pháp (parser), không thực thi code. Nó bắt được thiếu `fi`, thiếu `done`, quote chưa đóng. Cứ dùng làm bước rà đầu tiên mỗi khi gặp `syntax error` — đôi khi nó chỉ ra một lỗi lồng bên trong mà lỗi runtime giấu mất.

Nhược điểm: không bắt được lỗi lúc chạy, ví dụ biến chưa gán.

## 2. `bash -x` — in ra từng lệnh khi chạy

```sh
bash -x script.sh
```

In mọi lệnh **sau khi đã thay biến, bung glob...**, có dấu `+` ở đầu. Bạn thấy giá trị thật, không phải chữ trong source — cực kỳ hữu ích khi không hiểu vì sao một nhánh `if` lại chạy.

```
$ cat greet.sh
name="alice"
if [[ $name == a* ]]; then echo "hi $name"; fi

$ bash -x greet.sh
+ name=alice
+ [[ alice == a* ]]
+ echo 'hi alice'
hi alice
```

Bật tạm trong lúc chạy script:
```sh
set -x                      # bắt đầu theo dõi
# ... đoạn đang nghi ngờ ...
set +x                      # tắt theo dõi
```

## 3. Chỉnh `PS4` — cho dòng trace nhiều thông tin hơn

Cái tiền tố `+ ` mặc định hơi nghèo nàn. Định nghĩa lại `PS4` để kèm tên file, số dòng, tên hàm:

```sh
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x script.sh
```

Giờ mỗi dòng trace trông thế này:
```
+ greet.sh:3:main: [[ alice == a* ]]
+ greet.sh:3:main: echo 'hi alice'
```

Với script lớn thì nhìn phát ra ngay lỗi ở đâu.

## 4. `set -v` — in mỗi dòng đúng như trong source

```sh
set -v
```

Khác với `-x`: nó in **nguyên văn source** của từng dòng trước khi chạy (chưa thay biến). Hữu ích khi bạn muốn thấy script chảy qua here-doc và vòng lặp mà không bị nhiễu bởi phần đã bung ra.

## 5. `trap ERR` — xem lệnh nào đã "chết"

Với `set -e`, bất kỳ lệnh nào trả về khác 0 sẽ làm script dừng — nhưng mặc định bash không cho biết lệnh NÀO gục:

```sh
$ bash -e broken.sh
$ echo $?
1
```

Thêm dòng này:
```sh
trap 'echo "ERR at line $LINENO: $BASH_COMMAND (exit $?)" >&2' ERR
```

Giờ script hỏng sẽ tự khai:
```
ERR at line 42: rm -rf "$missing_dir" (exit 1)
```

Một kiểu "khám nghiệm hiện trường" rẻ mà hiệu quả. Nên đặt `set -euo pipefail` cùng trap này trong mọi script nghiêm túc.

## 6. `trap DEBUG` — móc vào trước MỖI lệnh

Cái này kích hoạt trước **mọi** lệnh, không chỉ lệnh lỗi. Dùng để log có cấu trúc mà không phải rải log khắp code:

```sh
trap 'printf "→ %s\n" "$BASH_COMMAND" >&2' DEBUG
```

Giống `set -x` nhưng bạn tự quyết định format — muốn thêm timestamp, cấp độ log, gì cũng được.

## 7. Vừa pipe output đi nơi khác, vừa xem được log

Đôi khi output của script là dữ liệu bạn đang pipe sang chỗ khác, nhưng bạn vẫn muốn nhìn thấy log. `tee` giúp tách đôi:

```sh
# Đặt ở đầu script:
exec > >(tee -a run.log) 2>&1
```

Giờ mọi thứ script in ra đều tới cả `run.log` lẫn màn hình. Phần `2>&1` ở cuối gom stderr vào chung đường ống.

## 8. Điểm dừng thủ công bằng `read`

Thêm một chỗ tạm dừng ở bất kỳ đâu:

```sh
echo "state at line $LINENO: count=$count"
read -r -p "press enter to continue... "
```

Tiện khi bạn không cần cả một debugger, chỉ muốn ngó nghiêng vài biến giữa các giai đoạn.

## 9. `bashdb` — một debugger thứ thiệt

Nếu trace vẫn chưa đủ, https://bashdb.sourceforge.net/ cho bạn breakpoint kiểu gdb, chạy từng bước, xem biến. Hiếm khi bõ công cài — 95% bug đầu hàng trước `set -x` — nhưng cứ để bụng cho những script rối thật sự.

## Triệu chứng thường gặp → nguyên nhân khả dĩ

| Triệu chứng | Nguyên nhân khả dĩ | Đọc thêm ở đâu |
|---|---|---|
| "Chạy tay thì được, cho vào cron thì hỏng" | `$PATH` khác, `.bashrc` không được nạp, shell không tương tác | Trang này + `man bash` mục `LOGIN SHELL` |
| "Command not found" chỉ khi ở trong script | Thiếu shebang, chưa `chmod +x`, hoặc PATH thiếu tool | `chmod +x`, `#!/usr/bin/env bash` |
| "unbound variable" | `set -u` phát nổ — gõ sai tên hoặc thiếu giá trị mặc định | Thêm `${var:-default}` hoặc soát lại chính tả |
| Vòng lặp đếm tới 5 nhưng cuối cùng ra 0 | Vòng lặp chạy trong subshell (nằm bên phải một pipe) | [learn/04-io-and-processes](../../../learn/04-io-and-processes/vi/notes.md) |
| Tham số có dấu cách bị tách thành 2 | Quên quote `$var` hoặc `${arr[@]}` | [topics/quoting](../../quoting/vi/README.md) |
| `cd` trong script không đổi thư mục của caller | `cd` chạy trong tiến trình con | Dùng `source script.sh` hoặc một alias |
| Script treo hoài không thoát | Đang chờ stdin đâu đó (thiếu `< /dev/null`?) hoặc chờ một tiến trình con | Thử `bash -x`, để ý `read` hay `wait` |
| `set -e` không thoát dù có lỗi | Lệnh nằm trong `if`, `while`, hoặc `\|\|` — `-e` bỏ qua các ngữ cảnh này | [learn/05-robust-scripts](../../../learn/05-robust-scripts/vi/notes.md) |

## Checklist debug cho mọi bug bash khó chịu

1. Chạy `shellcheck` trước — thường là cách sửa nhanh nhất.
2. Chạy với `bash -x` (hoặc `set -x` bao quanh khối nghi ngờ).
3. Thêm `trap 'echo "ERR at $LINENO: $BASH_COMMAND"' ERR`.
4. Soát lại quoting của từng `$var` trong vùng đó.
5. Nếu một biến "tự dưng đổi giá trị", nghi ngay có subshell.
6. Tái hiện lỗi với input tối giản nhất có thể.
7. Kẹt quá 30 phút thì đi giải thích cho một đồng nghiệp. Một nửa số lần, bạn tự bắt được lỗi ngay trong lúc nói ra.

## Tham chiếu chéo

- [topics/shellcheck](../../shellcheck/vi/README.md) — bắt lỗi từ trước khi chạy.
- [topics/quoting](../../quoting/vi/README.md) — chữa được 40% các ca "sao lại hỏng?".
- [learn/05-robust-scripts](../../../learn/05-robust-scripts/vi/notes.md) — strict mode và trap đặt trong ngữ cảnh thực.
