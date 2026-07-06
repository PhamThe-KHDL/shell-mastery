# 13-networking-2

## Goal
- Build on basic networking with more advanced SSH and netcat-based patterns.
- Learn enough to automate tunnels, proxies, and simple socket workflows without guessing.

## 1. Port forwarding is usually the first advanced SSH feature

The common local-forward pattern is:

```sh
ssh -L 8080:127.0.0.1:80 host
```

That means “bind local port 8080 and send traffic through SSH to port 80 on the remote side.”

This is incredibly useful when a service is only reachable from inside a host or VPC.

## 2. Jump hosts are normal, not exotic

If production is reachable only through a bastion:

```sh
ssh -J bastion target
```

That is easier to read than older `ProxyCommand` syntax and is the pattern to learn first.

## 3. `nc` is for quick socket experiments

`nc` is not a production application server. It is a debugging and exploration tool:

```sh
nc -l 9000
```

Use it to:

- open a quick listener
- test whether raw TCP traffic arrives
- understand what a client is actually sending

## 4. This layer becomes risky quickly

Advanced networking automation has more sharp edges than basic `curl`:

- auth and key management
- long-lived tunnels
- firewall policy
- accidental exposure of local services

So the main goal of this lesson is pattern recognition, not pretending shell should become your networking platform.

## Further reading
- `07-networking` first; this lesson assumes you already trust `curl`, `ssh`, and `nc`.
- `projects/ssh-tunnel-supervisor` in `ROADMAP.md` as the natural case-study follow-up.
