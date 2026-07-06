# 07-networking

## Mục tiêu
- Học các lệnh shell dùng nhiều nhất khi script phải giao tiếp qua mạng.
- Luyện cách fetch dữ liệu an toàn, kiểm tra kết nối, và bọc lệnh chạy từ xa.

## 1. `curl` là mặc định an toàn

Với shell script, `curl` thường là lựa chọn đầu tiên:

```sh
curl -fsS --max-time 5 https://example.com/health
```

- `-f` làm `curl` fail khi HTTP trả 4xx/5xx.
- `-sS` giữ output gọn khi thành công nhưng vẫn hiện lỗi.
- `--max-time 5` chặn trường hợp endpoint treo vô hạn.

Khi endpoint có thể chập chờn, thêm retry:

```sh
curl -fsS --retry 3 --retry-delay 1 URL
```

Chỉ retry khi request an toàn để lặp lại, ví dụ `GET` idempotent.

## 2. Reachable không đồng nghĩa healthy

Một service có thể mở port nhưng vẫn hỏng logic.

- `nc -z host port` trả lời câu hỏi “có mở cổng không?”
- `curl` trả lời câu hỏi “HTTP có phản hồi đúng không?”
- `dig` trả lời câu hỏi “DNS có resolve đúng không?”

Khi script mạng lỗi, đừng nhảy ngay vào retry. Hỏi đúng tầng trước:

1. DNS có đúng không?
2. Port có mở không?
3. Service có trả lời không?
4. Service có trả lời đúng status/body không?

## 3. SSH như primitive của shell

Đừng xem SSH chỉ là công cụ đăng nhập tay. Trong script, nó là một cách chạy command từ xa:

```sh
ssh web-01 uptime
ssh db-01 'df -h /var/lib/postgresql'
scp report.txt ops@host:/tmp/
```

Khi đưa SSH vào automation:

- quote cẩn thận command từ xa
- xử lý exit code rõ ràng
- tránh password prompt bất ngờ

Ví dụ:

```sh
ssh -o BatchMode=yes web-01 uptime
```

`BatchMode=yes` rất quan trọng trong CI/cron vì nó làm SSH fail ngay thay vì chờ nhập mật khẩu.

## 4. Failure mode thường gặp

- **DNS lỗi** — hostname không resolve.
- **Port đóng** — firewall hoặc service chưa mở.
- **Timeout** — mạng chậm hoặc endpoint treo.
- **Auth lỗi** — SSH key sai hoặc quyền chưa đủ.
- **Partial remote failure** — SSH thành công nhưng command bên kia fail.

Script tốt phải phân biệt được ít nhất “kết nối lỗi” với “remote command lỗi”.

## Đọc thêm
- Xem `ROADMAP.md` để biết bài này sẽ nối tiếp sang `13-networking-2`.
- Đọc `topics/portability` trước khi dựa vào các flag chỉ có trên Linux.
