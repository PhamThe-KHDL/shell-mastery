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

Ba pattern cần nhận ra là:

- local forward: `ssh -L local:dest_host:dest_port host`
- remote forward: `ssh -R remote:dest_host:dest_port host`
- dynamic SOCKS proxy: `ssh -D 1080 host`

Với hầu hết người học, `-L` là loại nên nắm đầu tiên.

## 2. Jump host là chuyện bình thường

Nếu production chỉ vào được qua bastion:

```sh
ssh -J bastion target
```

Pattern này dễ đọc hơn `ProxyCommand` cũ và là thứ nên học trước tiên.

Nếu bạn hay đi cùng một route, hãy chuyển nó vào `~/.ssh/config`:

```sshconfig
Host prod
    HostName prod.internal
    User deploy
    ProxyJump bastion
```

Khi đó chỉ cần `ssh prod`.

## 3. `nc` để thử nghiệm socket nhanh

`nc` không phải application server cho production. Nó là công cụ debug và khám phá:

```sh
nc -l 9000
```

Dùng nó để:

- mở listener nhanh
- test xem raw TCP traffic có tới không
- hiểu client thực sự đang gửi gì

Ví dụ, ở terminal thứ nhất:

```sh
nc -l 9000
```

Ở terminal thứ hai:

```sh
printf 'hello\r\n' | nc 127.0.0.1 9000
```

Bài thử rất nhỏ này dạy được khá nhiều về hành vi TCP thuần.

Lưu ý rằng cờ của `nc` khác nhau giữa các implementation. OpenBSD `nc` và GNU `netcat` khá giống nhau nhưng không hoàn toàn giống, nên luôn kiểm tra `man nc` trên máy bạn đang dùng.

## 4. Tunnel sống lâu cần thêm vài cờ SSH

Đăng nhập tương tác không phải lúc nào cũng là điều bạn muốn. Với một phiên chỉ để mở tunnel:

```sh
ssh -N -L 8080:127.0.0.1:80 host
```

`-N` nghĩa là "không chạy remote command". Bạn cũng thường gặp:

- `-f` để đẩy SSH xuống background sau khi xác thực
- `-o ExitOnForwardFailure=yes` để fail nhanh nếu tunnel không tạo được
- `-o ServerAliveInterval=30` cho kết nối sống lâu

Đây là các cờ biến một lệnh "chạy được trên máy tôi" thành thứ có thể automation tương đối ổn.

## 5. Tầng này sắc hơn networking cơ bản rất nhiều

Automation mạng nâng cao có nhiều cạnh sắc hơn `curl`:

- auth và quản lý key
- tunnel sống lâu
- firewall policy
- vô tình expose local service

Vì vậy mục tiêu chính của bài này là nhận diện pattern, chứ không giả vờ shell nên trở thành platform mạng hoàn chỉnh.

## Đọc thêm
- Học `07-networking` trước; bài này giả định bạn đã quen `curl`, `ssh`, và `nc`.
- `projects/ssh-tunnel-supervisor` trong `ROADMAP.md` là case study tự nhiên tiếp theo.
