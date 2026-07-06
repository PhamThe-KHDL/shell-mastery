# Bài tập 01 · Basics

Làm xong đối chiếu với [`solutions.md`](solutions.md).

## 1. Redirect
Viết 1 lệnh chạy `ls /nope /tmp` sao cho stdout vào `out.txt`, stderr vào `err.txt`, và chương trình vẫn báo exit code 0.

## 2. Đếm dòng khớp
Cho lệnh `find / -name '*.conf' 2>/dev/null`, đếm số dòng **kết quả** (không phải lỗi). Không dùng file tạm.

## 3. Quoting
Tạo file tên `-rf ~` (có, thật đấy). Xoá nó **an toàn** không dùng `rm --`. Gợi ý: đường dẫn.

## 4. Glob
In ra mọi file `.sh` trong repo này, kể cả file lồng sâu. Bash mặc định không đệ quy — bạn cần bật gì?
