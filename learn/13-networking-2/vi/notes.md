# 13-networking-2

## Mục tiêu
- Mở rộng networking cơ bản sang các pattern nâng cao với SSH và netcat.
- Học đủ để tự động hóa tunnel, proxy, và socket workflow đơn giản mà không đoán mò.

## 1. Port forwarding thường là tính năng SSH nâng cao đầu tiên bạn cần

Pattern local forward phổ biến:

```sh
ssh -L 8080:127.0.0.1:80 host
```

Nghĩa là “bind local port 8080 và gửi traffic qua SSH tới port 80 ở phía remote”.

Nó cực kỳ hữu ích khi service chỉ truy cập được từ bên trong host hoặc VPC.

## 2. Jump host là chuyện bình thường

Nếu production chỉ vào được qua bastion:

```sh
ssh -J bastion target
```

Pattern này dễ đọc hơn `ProxyCommand` cũ và là thứ nên học trước tiên.

## 3. `nc` để thử nghiệm socket nhanh

`nc` không phải application server cho production. Nó là công cụ debug và khám phá:

```sh
nc -l 9000
```

Dùng nó để:

- mở listener nhanh
- test xem raw TCP traffic có tới không
- hiểu client thực sự đang gửi gì

## 4. Tầng này sắc hơn networking cơ bản rất nhiều

Automation mạng nâng cao có nhiều cạnh sắc hơn `curl`:

- auth và quản lý key
- tunnel sống lâu
- firewall policy
- vô tình expose local service

Vì vậy mục tiêu chính của bài này là nhận diện pattern, chứ không giả vờ shell nên trở thành platform mạng hoàn chỉnh.

## Đọc thêm
- Học `07-networking` trước; bài này giả định bạn đã quen `curl`, `ssh`, và `nc`.
- `projects/ssh-tunnel-supervisor` trong `ROADMAP.md` là case study tự nhiên tiếp theo.
