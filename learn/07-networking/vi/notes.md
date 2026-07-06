# 07-networking

## Mục tiêu
- Học các lệnh shell bạn nên dùng đầu tiên khi script phải giao tiếp qua mạng.
- Luyện cách fetch dữ liệu an toàn, kiểm tra kết nối, và bọc command chạy từ xa.

## 1. Ưu tiên `curl`, không phải `wget`

Với script, `curl` thường là mặc định tốt hơn vì hành vi dễ đoán và dễ ghép vào pipeline:

```sh
curl -fsS --max-time 5 https://example.com/health
```

- `-f` làm `curl` fail khi HTTP trả 4xx/5xx thay vì in HTML lỗi rồi exit 0.
- `-sS` giữ output gọn khi thành công nhưng vẫn hiện lỗi.
- `--max-time 5` chặn trường hợp endpoint treo vô hạn.

Chỉ thêm retry khi thao tác an toàn để lặp lại:

```sh
curl -fsS --retry 3 --retry-delay 1 URL
```

## 2. Reachable không đồng nghĩa correct

Một service có thể mở port nhưng vẫn hỏng logic.

- `nc -z host port` kiểm tra TCP port có reachable không.
- `curl` kiểm tra HTTP service có trả status/body đúng không.
- `dig` hữu ích khi nghi lỗi nằm ở DNS chứ không phải service.

## 3. SSH như primitive của script

Hãy xem SSH như một phương tiện vận chuyển command:

```sh
ssh web-01 uptime
ssh db-01 'df -h /var/lib/postgresql'
scp report.txt ops@host:/tmp/
```

Những rule shell quen thuộc vẫn giữ nguyên:

- quote remote command cẩn thận
- xử lý exit code rõ ràng
- dự đoán trước auth failure, DNS failure, và timeout

## 4. Checklist debug cơ bản

Khi script mạng lỗi, hãy hỏi theo thứ tự này:

1. DNS có resolve không?
2. Port có mở không?
3. Phía bên kia có trả lời không?
4. Nó có trả về đúng status mình mong đợi không?
5. Lỗi này có đủ “thoáng qua” để đáng retry không?

## 5. Default an toàn

Các default tốt cho shell networking:

```sh
curl -fsS --max-time 5 URL
ssh -o BatchMode=yes host cmd
nc -z host port
```

`BatchMode=yes` rất quan trọng trong automation: nó bảo SSH đừng dừng lại chờ password prompt mà bạn sẽ không bao giờ nhìn thấy trong cron hay CI.

## Đọc thêm
- Xem `ROADMAP.md` để biết bài này nối tiếp sang `13-networking-2`.
- Đọc `topics/portability` trước khi dựa vào networking flags chỉ có trên Linux.
