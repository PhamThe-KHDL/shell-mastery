# lib

Sourceable helper libraries. Not standalone scripts — you `source` (or `.`) them into your own script. Every library here has a matching bats test suite under `tests/lib_<name>.bats` and passes `shellcheck --severity=warning`.

## Available libraries

| File | Provides | Requires |
|---|---|---|
| [`logger.sh`](logger.sh)   | `log_debug`, `log_info`, `log_warn`, `log_error` with `LOG_LEVEL` env var and colored stderr when a TTY | bash 4+ |
| [`retry.sh`](retry.sh)     | `retry MAX DELAY CMD...` with exponential backoff | bash 4+ |
| [`tempdir.sh`](tempdir.sh) | `make_tempdir` → prints a fresh temp dir path, registered for auto-cleanup on script exit | bash 4+ |
| [`strings.sh`](strings.sh) | `trim`, `lower`, `upper`, `starts_with`, `ends_with`, `contains`, `join` — all fork-free | bash 4+ |

## How to source a library

```sh
#!/usr/bin/env bash
set -euo pipefail

# Resolve lib path relative to this script — works even when called from elsewhere.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# shellcheck source=/dev/null
. "$SCRIPT_DIR/lib/logger.sh"

log_info "starting up"
```

The `# shellcheck source=/dev/null` comment silences SC1091 (shellcheck can't follow dynamic paths). Alternatively, hard-code the path: `# shellcheck source=lib/logger.sh`.

## Usage examples

### logger.sh

```sh
. lib/logger.sh
log_info "connecting to $host"
log_warn "config missing $KEY, using default"
log_error "cannot open $file"

# Suppress info messages
LOG_LEVEL=warn ./myscript.sh
```

Output goes to stderr, so `./myscript.sh > data.txt` still gets logs on the terminal.

### retry.sh

```sh
. lib/retry.sh

# Try up to 5 times, initial delay 1s (grows to 2, 4, 8, 16)
retry 5 1 curl -fsS https://flaky-api/data

# Guard the call so a final failure aborts the script
if ! retry 3 2 ssh user@host uptime; then
    log_error "host unreachable after 3 tries"
    exit 1
fi
```

### tempdir.sh

```sh
. lib/tempdir.sh

# Each call registers a new dir for cleanup on script exit
work=$(make_tempdir)
scratch=$(make_tempdir)

cp -a "$source" "$work"
transform "$work" > "$scratch/output"
# ... no cleanup code needed. Both dirs are deleted when the script exits,
# whether normally, via error, or via signal.
```

When you source `tempdir.sh`, it preserves any existing `EXIT` trap by appending `_tempdir_cleanup`. If you replace `trap EXIT` later in your script, include `_tempdir_cleanup` in the new handler so temp dirs still get removed.

### strings.sh

```sh
. lib/strings.sh

name=$(trim "   alice   ")            # → "alice"
[[ $(lower "$FILE") == *.gz ]]        # case-insensitive suffix check
starts_with "https://" "$url" && echo "secure"
csv=$(join , alice bob carol)         # → "alice,bob,carol"
```

All string helpers use bash parameter expansion — zero external process spawns.

## Promoting a snippet to `lib/`

The distinction is testability. A `snippets/` file is a copy-paste template you paste into a script; a `lib/` file has:

1. A stable public interface — function names and args don't change.
2. A bats test suite in `tests/lib_<name>.bats`.
3. Zero external dependencies unless documented at the top.
4. Passes shellcheck at `--severity=warning`.

When you find yourself sourcing the same snippet in three scripts, that's the signal to move it.
