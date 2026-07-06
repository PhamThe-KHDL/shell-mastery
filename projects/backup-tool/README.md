# backup-tool

A production-shaped bash script that creates timestamped `.tar.gz` archives of a source directory, keeps only the last N archives, and does everything atomically — so a crash mid-run never leaves half-written files at the destination.

Designed to run from cron or as a systemd timer.

## Usage

```sh
./backup.sh -s SOURCE -d DEST -n NAME [-k KEEP] [--dry-run]
```

### Options

| Flag | Description | Required | Default |
|---|---|:-:|---|
| `-s`, `--source PATH` | Directory to back up. Must exist. | ✅ | — |
| `-d`, `--dest PATH`   | Directory where archives are written. Must exist and be writable. | ✅ | — |
| `-n`, `--name NAME`   | Base name of the archive. Files are named `NAME-YYYYMMDD-HHMMSS.tar.gz`. | ✅ | — |
| `-k`, `--keep N`      | Number of most recent archives to retain. Older ones are deleted. | ❌ | `5` |
| `--dry-run`           | Print what would happen, change nothing. | ❌ | off |
| `-h`, `--help`        | Show help and exit. | ❌ | — |

### Examples

Back up your notes daily, keep a week:
```sh
./backup.sh -s ~/notes -d /var/backups/notes -n notes -k 7
```

Preview what a run would do without touching anything:
```sh
./backup.sh -s ./src -d /tmp -n src --dry-run
```

Long-form flags work identically:
```sh
./backup.sh --source ~/notes --dest /var/backups/notes --name notes --keep 30
```

### Cron example

```
# Daily at 2:30 AM, keep 30 days
30 2 * * * /path/to/backup.sh -s /home/me -d /mnt/backup -n home -k 30 >> /var/log/home-backup.log 2>&1
```

## Sample output

```
$ ./backup.sh -s ~/notes -d /tmp -n notes -k 3
creating /tmp/notes-20241015-023045.tar.gz from /home/me/notes
done: /tmp/notes-20241015-023045.tar.gz

$ ls /tmp/notes-*
/tmp/notes-20241013-023001.tar.gz
/tmp/notes-20241014-023011.tar.gz
/tmp/notes-20241015-023045.tar.gz
# older archives were pruned
```

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Success. |
| `1` | Runtime error — source missing, destination not writable, tar failed, etc. Message is on stderr. |
| `2` | Misuse — missing required flag, unknown flag, invalid value for `-k`. |

Handy for cron: check `$?` in a wrapper if you want to trigger an alert only on real failures (exit 1), not misconfiguration (exit 2).

## Design highlights (read alongside the script)

- **Atomic write** — `tar` writes to a hidden temp file inside the destination directory (`.NAME.XXXXXX.tar.gz`). Only after success does `mv` rename it to the final name. Because `mv` on the same filesystem is atomic, callers see either "no new archive" or "complete archive" — never a partial one.
- **Guaranteed cleanup** — a `trap ... EXIT` removes the temp file if the script dies before `mv`. After a successful `mv`, `trap - EXIT` cancels the trap so the (now-renamed) file isn't deleted.
- **Retention on sorted output** — `find | sort -r` gives archives newest-first. `${arr[@]:keep}` slices off the ones past the keep threshold; no arithmetic errors even when there are fewer archives than `KEEP`.
- **Dry-run via a `run()` wrapper** — one branch per action instead of scattering `if $dry_run` checks across the script.
- **Long AND short flags** — the argument parser accepts both `-s` and `--source PATH` (and `--source=PATH`), so muscle memory from other CLIs works.

## Failure modes and what happens

| Scenario | Result |
|---|---|
| Source dir missing | Exit 1, stderr message. No changes. |
| Dest dir not writable | Exit 1 during `mktemp`. No changes. |
| Out of disk mid-`tar` | `tar` fails, `set -e` stops the script, `trap` deletes the temp file. Final archive path is untouched. |
| Ctrl-C mid-`tar`      | Same as above — trap cleans up. |
| `mv` fails            | Temp file cleaned up; original archives untouched. |

## Tests

```sh
bats tests/projects_backup_tool.bats
```

Covers: missing flags, successful archive creation, archive contents, retention math, dry-run inertness, invalid source.

## Try breaking it

Ideas for extending or hardening:

- Add `--exclude PATTERN` (passthrough to `tar --exclude`).
- Add SHA-256 checksum next to each archive.
- Add a `--to REMOTE` option that `scp`s the archive off-box after creation.
- Add pre/post hooks — user-supplied scripts to run before archive and after `mv`.

Each of these teaches something: argument parsing, hash tooling, error propagation over the network, hookable design.
