# log-analyzer

Reads a web-server access log in **Combined Log Format** and prints a human summary: totals, top clients, status distribution, top requested paths, and every 5xx line.

Reads from stdin or a file — designed to plug into `zcat`, `ssh`, `journalctl`, or `find` pipelines.

## Usage

```sh
./analyze.sh [-n N] [FILE]
```

| Flag | Description | Default |
|---|---|---|
| `-n N` | Show top-N entries per section. Must be a positive integer. | `10` |
| `-h`   | Show help. | — |

If `FILE` is omitted, the script reads from stdin.

## Log format

Standard Apache/Nginx Combined Log Format — the default for both:

```
IP - - [DATE] "METHOD PATH HTTP/VER" STATUS BYTES "REFERER" "USER-AGENT"
```

Example line:
```
10.0.0.1 - - [10/Oct/2024:13:55:36 +0000] "GET /index.html HTTP/1.1" 200 512 "-" "curl/8"
```

If your log uses a different format, edit the field indexes in `analyze.sh` (`$1` is IP, `$7` is path, `$9` is status).

## Examples

Analyze a plain log:
```sh
./analyze.sh /var/log/nginx/access.log
```

Analyze the checked-in sample fixture so you can see expected behavior immediately:
```sh
./analyze.sh ../../tests/fixtures/log-analyzer.sample.log
```

Analyze a compressed log without unpacking to disk:
```sh
zcat /var/log/nginx/access.log.1.gz | ./analyze.sh
```

Only the top 3 of each section:
```sh
./analyze.sh -n 3 /var/log/nginx/access.log
```

Pull today's log from a remote server and analyze locally:
```sh
ssh web-01 'tail -n 10000 /var/log/nginx/access.log' | ./analyze.sh -n 20
```

Merge multiple servers:
```sh
{ ssh web-01 cat /var/log/nginx/access.log;
  ssh web-02 cat /var/log/nginx/access.log; } | ./analyze.sh
```

## Sample output

```
==== Summary ====
total requests: 4832
unique IPs:     217

==== Top 10 clients ====
  921    10.0.0.4
  483    172.16.5.11
  204    203.0.113.7
  ...

==== Status code distribution ====
  4103   200
  512    304
  147    404
  70     500
  ...

==== Top 10 paths ====
  1204   /
  832    /api/status
  611    /favicon.ico
  ...

==== 5xx errors ====
10.0.0.9 - - [10/Oct/2024:14:22:01 +0000] "POST /api/checkout HTTP/1.1" 500 79 "-" "MyApp/1.4"
10.0.0.9 - - [10/Oct/2024:14:22:03 +0000] "POST /api/checkout HTTP/1.1" 500 79 "-" "MyApp/1.4"
...
```

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Success. |
| `2` | Misuse — invalid `-n`, or unknown flag. |

The script doesn't fail on an empty log — it prints `total requests: 0` and empty sections. That's often useful information itself.

## Design highlights

- **Read once, analyze multiple times** — because the input might be stdin, we `cat` it to a temp file first and clean up on `EXIT`. This lets each `awk` section run independently instead of complicating one giant `awk` script.
- **Pure `awk` per section** — no `while read` loops means no subshell traps, and it scales to gigabytes of log with constant memory.
- **`getopts` for short flags only** — this script only has two flags; a long-option parser would be overkill. Compare with [`backup-tool`](../backup-tool/) which needs both.
- **Numeric flag validation** — `[[ $top =~ ^[0-9]+$ && $top -gt 0 ]]` rejects `-n abc` and `-n 0` before doing any work.

## Failure modes

| Scenario | Result |
|---|---|
| Empty log | Runs to completion; all counts are 0. |
| Malformed line | `awk` skips it silently — usually the right behavior for logs. |
| Non-existent input file | Bash exits with the shell's cat error message. |
| Line without a status field | Contributes to `""` in the distribution — surfaces the corruption. |

## Tests

```sh
bats tests/projects_log_analyzer.bats
```

Covers: totals, uniques, top-client accuracy, 5xx section, stdin mode, `-n` validation. The test fixture also lives in-tree at [`tests/fixtures/log-analyzer.sample.log`](../../tests/fixtures/log-analyzer.sample.log) so readers can run the project without needing a real web-server log first.

## Try breaking it

Extensions worth attempting:

- Add `-f FORMAT` to accept common format IDs (`combined`, `common`, `json`).
- Add a `--since TIME` filter using the timestamp in field 4.
- Emit JSON so it can feed into `jq` or a dashboard.
- Add per-hour or per-status heatmaps (still doable in pure `awk`).
