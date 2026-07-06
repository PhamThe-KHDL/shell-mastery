# Lời giải 13-networking-2

## 1. Forward một local port

```bash
ssh -L 8080:127.0.0.1:80 host
```

Lệnh này bind port `8080` trên máy bạn rồi forward traffic qua SSH tới port `80` theo góc nhìn từ `host`.

## 2. Listen với netcat

Ở terminal thứ nhất:

```bash
nc -l 9000
```

Ở terminal thứ hai:

```bash
printf 'hello\r\n' | nc 127.0.0.1 9000
```

Mục tiêu là quan sát byte đi từ đầu này sang đầu kia và xác nhận listener nhận đúng thứ mà client gửi.

## 3. Mô tả jump-host flow

```bash
ssh -J bastion target
```

Lệnh này nghĩa là "kết nối tới `target` thông qua `bastion`". Đây là dạng hiện đại và dễ đọc hơn so với pattern `ProxyCommand` cũ.
