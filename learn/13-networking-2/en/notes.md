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

The three patterns to recognize are:

- local forward: `ssh -L local:dest_host:dest_port host`
- remote forward: `ssh -R remote:dest_host:dest_port host`
- dynamic SOCKS proxy: `ssh -D 1080 host`

For most learners, `-L` is the one to master first.

## 2. Jump hosts are normal, not exotic

If production is reachable only through a bastion:

```sh
ssh -J bastion target
```

That is easier to read than older `ProxyCommand` syntax and is the pattern to learn first.

If you use the same route often, move it into `~/.ssh/config`:

```sshconfig
Host prod
    HostName prod.internal
    User deploy
    ProxyJump bastion
```

Then `ssh prod` becomes enough.

## 3. `nc` is for quick socket experiments

`nc` is not a production application server. It is a debugging and exploration tool:

```sh
nc -l 9000
```

Use it to:

- open a quick listener
- test whether raw TCP traffic arrives
- understand what a client is actually sending

For example, in terminal one:

```sh
nc -l 9000
```

In terminal two:

```sh
printf 'hello\r\n' | nc 127.0.0.1 9000
```

That tiny setup teaches a lot about plain TCP behavior.

Be aware that `nc` flags vary across implementations. OpenBSD `nc` and GNU `netcat` are similar, but not identical, so always check `man nc` on the machine you are teaching from.

## 4. Long-lived tunnels need a few extra SSH flags

Interactive login is not always what you want. For a tunnel-only session:

```sh
ssh -N -L 8080:127.0.0.1:80 host
```

`-N` says "do not run a remote command." You may also see:

- `-f` to send SSH to the background after auth
- `-o ExitOnForwardFailure=yes` to fail fast if the tunnel could not be created
- `-o ServerAliveInterval=30` for long-lived connections

These are the flags that turn "works on my laptop" into "reasonable automation."

## 5. This layer becomes risky quickly

Advanced networking automation has more sharp edges than basic `curl`:

- auth and key management
- long-lived tunnels
- firewall policy
- accidental exposure of local services

So the main goal of this lesson is pattern recognition, not pretending shell should become your networking platform.

## Further reading
- `07-networking` first; this lesson assumes you already trust `curl`, `ssh`, and `nc`.
- `projects/ssh-tunnel-supervisor` in `ROADMAP.md` as the natural case-study follow-up.
