# Solutions 13-networking-2

## 1. Forward one local port

```bash
ssh -L 8080:127.0.0.1:80 host
```

This binds port `8080` on your machine and forwards traffic through SSH to port `80` as seen from `host`.

## 2. Listen with netcat

In terminal one:

```bash
nc -l 9000
```

In terminal two:

```bash
printf 'hello\r\n' | nc 127.0.0.1 9000
```

The point is to watch bytes move end-to-end and confirm that the listener receives what the client sent.

## 3. Describe a jump-host flow

```bash
ssh -J bastion target
```

This means "connect to `target` through `bastion`." It is the modern readable form of the old `ProxyCommand` pattern.
