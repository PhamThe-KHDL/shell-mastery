# 09-processes

## Goal
- Understand the process-level commands that matter once scripts start running unattended.
- Learn how to inspect, signal, background, and prioritize work safely.

## 1. Inspect first, kill second

When something “looks stuck,” do not jump straight to `kill -9`.
Inspect it:

```sh
ps -ef | grep '[s]sh'
pgrep ssh
lsof -p "$pid"
```

`pgrep` is the cleanest way to find matching processes by name. `lsof` tells you what files and sockets a process currently holds.

## 2. Background jobs are still your responsibility

Starting a command with `&` only launches it in the background. You still need to manage it:

```sh
sleep 10 &
pid=$!
wait "$pid"
```

`$!` is the PID of the most recently backgrounded process.

If you start several jobs, store each PID and wait for them intentionally.

## 3. Signals should escalate in order

Default escalation path:

1. `TERM` — polite request to stop
2. wait a moment
3. `KILL` only if the process ignored `TERM`

That pattern avoids corrupting state or leaving half-written files when a process could have shut down cleanly.

## 4. Long-running jobs and detaching

- `nohup cmd &` keeps a job alive after you close the terminal
- `disown` removes a job from the shell's job table
- `wait` is how scripts synchronize with their children

These tools matter most once scripts run under cron, CI, or supervision.

## 5. Priority and troubleshooting

If a job is too heavy, do not optimize blindly first:

```sh
nice -n 10 my_job
ionice -c3 my_job
```

And if a process behaves mysteriously:

- `strace` shows syscalls
- `lsof` shows open files/sockets
- `ps`/`top` show CPU and memory pressure

You do not need every flag now; just know these tools exist and what question each one answers.

## 6. Platform caveats

Process tooling is one of the least portable parts of shell work:

- `ps` output differs between Linux, macOS, and BSD.
- `lsof` is common on both Linux and macOS, but options still vary.
- `strace` and `ionice` are Linux tools; on macOS you may reach for `dtruss`, `fs_usage`, or Activity Monitor instead.
- `systemctl` is not part of this lesson's toolbox because it does not exist on macOS and many non-systemd systems.

Write scripts around the portable questions first: "what PID do I need?", "did it exit?", and "can I wait for it cleanly?" Then branch into platform-specific helpers only when you truly need them.

## Further reading
- `04-io-and-processes` for the earlier foundation on jobs and traps.
- `projects/` for examples of scripts that clean up on exit.
