# Topic · Portability — bash vs POSIX sh vs BSD tools

> 🌐 **English** · [Tiếng Việt](../vi/README.md)

Portability isn't a virtue in itself. It's a cost paid for a benefit: your script runs unchanged on Alpine containers, BusyBox routers, macOS's ancient bash, and old servers you can't upgrade. If you don't need those, don't pay the cost.

This page helps you decide, then covers the practical differences when you have decided.

## Decide the target BEFORE writing

Three tiers, from least to most portable:

### Tier 1 — bash 4+ (`#!/usr/bin/env bash`)

You get arrays, associative arrays, `[[ ]]`, `${var/a/b}`, process substitution, `local -n`, `mapfile`, `${var,,}`. Runs on every Linux, and on macOS if the user installed a modern bash (`brew install bash`).

**Choose this for**: personal scripts, team internal tools, Docker images with a `RUN apt install bash`.

### Tier 2 — bash 3.2 (`#!/bin/bash`)

The macOS default (frozen 2007). No associative arrays, no `mapfile`, no `${var,,}`, no `local -n`. You still have arrays, `[[ ]]`, and process substitution.

**Choose this for**: scripts intended to run on unmodified macOS out of the box.

### Tier 3 — POSIX sh (`#!/bin/sh`)

Runs everywhere. No arrays, no `[[ ]]`, no process substitution, no `local` (strictly). On Alpine `sh` is BusyBox `ash`, on Debian it's `dash`, on macOS it's actually bash-in-POSIX-mode.

**Choose this for**: installer scripts you distribute via `curl | sh`, service init scripts on Alpine containers, embedded systems.

**The trap**: writing bash and shebanging it `#!/bin/sh`. It runs on your machine (because your `sh` is bash) and fails on Alpine (because ash doesn't know `[[ ]]`). Run `shellcheck --shell=sh` to catch this.

## bash vs POSIX sh — most-used differences

| Bash | POSIX equivalent |
|---|---|
| `[[ x == y ]]` | `[ "$x" = "$y" ]` |
| `[[ $s =~ regex ]]` | `case "$s" in pattern) ... esac` or `expr` |
| `arr=(a b)` | (none — use positional params or newline-separated string) |
| `${arr[@]}` | (none) |
| `${var,,}` (lowercase) | `echo "$var" \| tr A-Z a-z` |
| `${var:0:3}` (substring) | `echo "$var" \| cut -c1-3` or `expr substr` |
| `$((x++))` | `x=$((x + 1))` |
| `<(cmd)` process substitution | Temp file |
| `read -r -a arr` | (none) |
| `local x` inside function | Not strictly POSIX; dash/ash/bash all support it in practice |
| `echo -e "\t"` | `printf '\t'` |
| `${!var}` (indirect) | `eval` (yes, `eval`) |

**Take-away**: an equivalent almost always exists in POSIX, but it's uglier and often forks a helper process (`tr`, `cut`, `expr`). That's the real cost of Tier 3.

## bash 4 vs bash 3.2 (macOS)

The killer features you lose on macOS default bash:

- Associative arrays (`declare -A`).
- `mapfile` / `readarray`.
- `${var,,}`, `${var^^}` (case conversion).
- `${!prefix*}` (variable name enumeration).
- `local -n` nameref (also missing in 4.0–4.2).

If you want your script to Just Work on unmodified macOS, avoid these. Otherwise `brew install bash` and require `bash 4+` in your prerequisites.

## Common tool differences (macOS BSD vs Linux GNU)

### `sed -i` (in-place)

```sh
sed -i 's/x/y/' file          # GNU — works
sed -i '' 's/x/y/' file       # BSD — needs the '' argument
sed -i.bak 's/x/y/' file      # BOTH — makes a .bak file, then rm it
```

The `.bak` trick is the portable form. Almost every script that does in-place editing across platforms uses it.

### `date` arithmetic

```sh
# "Yesterday" in ISO format:
date -d 'yesterday' +%F         # GNU
date -v-1d +%F                  # BSD
```

Sane approach for anything non-trivial: shell out to Python:
```sh
python3 -c 'from datetime import date, timedelta; print(date.today()-timedelta(days=1))'
```

### `readlink -f` (canonicalize path)

```sh
readlink -f "$path"             # GNU — resolves symlinks fully
# BSD readlink has no -f. Alternatives:
python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$path"

# Or shell-only:
cd -P -- "$(dirname -- "$path")" && printf '%s/%s\n' "$(pwd -P)" "$(basename -- "$path")"
```

### `grep -P` (Perl regex)

GNU only. Use `grep -E` (extended regex) when possible — it covers 95% of Perl regex uses. If you truly need PCRE, install `pcregrep` or write it in awk/Python.

### `stat`

```sh
stat -c '%s' file        # GNU: file size
stat -f '%z' file        # BSD: file size
```

Different flag AND different format specifiers. Portable: use `wc -c < file` for size.

### `xargs -P` (parallelism)

Both support it. GNU also has `-r` (do nothing on empty input) which BSD doesn't. Portable idiom: `xargs -0 -I{}` if you might get zero inputs.

### `mktemp`

```sh
mktemp                          # both, gives a fresh file path
mktemp -d                       # both, directory
mktemp /tmp/foo.XXXXXX          # both, custom template
mktemp --tmpdir=/x foo.XXXXXX   # GNU only
```

Stick to the templates and dirs, avoid GNU-only flags.

## Testing portability

Three complementary approaches:

### 1. Static — shellcheck

```sh
shellcheck --shell=sh script.sh          # for POSIX targets
shellcheck --shell=bash script.sh        # for bash targets
```

Catches bashisms in POSIX scripts and vice versa.

### 2. Container — Alpine

Ship your script into an Alpine container and see if it runs:
```sh
docker run --rm -v "$PWD:/app" alpine sh /app/script.sh
```

Alpine's `sh` is BusyBox `ash` — the strictest common target for POSIX scripts. If it runs here, it runs almost anywhere.

### 3. Dual-tool install — GNU + BSD side-by-side

On macOS:
```sh
brew install gnu-sed coreutils gnu-tar findutils
```

They install as `gsed`, `gcp`, `gtar`, `gfind`. Test both:
```sh
gsed --version
printf 'x\n' >/tmp/sed-test && sed -i.bak 's/x/y/' /tmp/sed-test && cat /tmp/sed-test
```

GNU `sed` advertises itself with `--version`; BSD `sed` usually does not. For BSD/macOS, verify behavior with a tiny real edit instead of expecting a version flag.

Now you can write scripts that work with either, and verify at write time.

## Practical recommendations

- **Your workstation dev scripts**: bash 4+. Don't over-engineer.
- **Team internal tools**: bash 4+, document the requirement in your README.
- **Docker images you maintain**: whatever the base image ships. `apt install bash` in Debian is fine; on Alpine, either install bash or write for `ash`.
- **User-facing installers (`curl \| sh`)**: POSIX sh, test in Alpine.
- **Anything on a shared server**: check `bash --version` first; write for the lowest.

## Cross-reference

- [shells/posix-sh](../../../shells/posix-sh/README.md) — POSIX idioms.
- [shells/bash](../../../shells/bash/README.md) — bash versioning.
- [topics/shellcheck](../../shellcheck/en/README.md) — the `--shell=sh` flag catches bashisms.
