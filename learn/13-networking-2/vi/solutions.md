# Lời giải 13-networking-2

## 1.
Đây là pattern kinh điển `ssh -L 8080:127.0.0.1:80 host`.

## 2.
Một terminal listen; terminal còn lại connect. Mục tiêu là quan sát hành vi socket thô.

## 3.
Ưu tiên `ssh -J bastion target` nếu SSH của bạn hỗ trợ, thay vì `ProxyCommand` cũ.
