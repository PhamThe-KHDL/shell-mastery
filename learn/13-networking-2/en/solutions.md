# Solutions 13-networking-2

## 1.
This is the classic `ssh -L 8080:127.0.0.1:80 host` pattern.

## 2.
One terminal listens; another connects. The goal is to observe raw socket behavior, not build a server.

## 3.
Prefer `ssh -J bastion target` over older `ProxyCommand` forms when available.
