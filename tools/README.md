# tools

Repo-management scripts. These aren't lesson material — they exist so the repo stays consistent as it grows.

Every tool is itself a bash script that follows this repo's own conventions, so you can also read them as small worked examples of `getopts`, `find`, arg validation, and shellcheck-clean style.

## Available tools

| Script | What it does | When to run |
|---|---|---|
| [`check-deps.sh`](check-deps.sh)  | Verifies bash 4+, shellcheck, bats, and shfmt are installed | First-time setup, or when a script errors with "command not found" |
| [`new-lesson.sh`](new-lesson.sh)  | Scaffolds a new `learn/NN-slug/` folder with `en/`, `vi/`, and `examples/` templates | Before writing a new lesson — saves manual mkdir + boilerplate |
| [`lint-all.sh`](lint-all.sh)      | Runs `shellcheck --severity=warning` on every `.sh` file in the repo | Before every commit; also runs in CI |

## Usage

### check-deps.sh

```sh
$ ./tools/check-deps.sh
Checking tools:
  ✅ bash         GNU bash, version 5.2.15(1)-release (aarch64-apple-darwin23)
  ✅ shellcheck   ShellCheck - shell script analysis tool
  ✅ bats         Bats 1.10.0
  ✅ shfmt        v3.7.0

✅ All required tools installed.
```

Exit code is 1 if anything is missing, 0 otherwise — safe to gate other scripts on it.

### new-lesson.sh

```sh
./tools/new-lesson.sh 07-networking
```

Creates:
```
learn/07-networking/
├── en/{notes,exercises,solutions}.md
├── vi/{notes,exercises,solutions}.md
└── examples/01-hello.sh
```

All prose files start with a `TODO` outline; the example is a runnable stub. After running, add a row to [`learn/INDEX.md`](../learn/INDEX.md) — the tool prints a reminder.

Naming convention:
- Prefix with a two-digit number (`07-...`), padded so `ls` sorts correctly.
- Slug in kebab-case, lowercase.
- Reserved numbers 01–06 are taken by the current curriculum.

### lint-all.sh

```sh
$ ./tools/lint-all.sh
Linting 28 files...
✅ Clean.
```

Uses `find` + `-exec shellcheck` so it works on macOS's bash 3.2 (no `mapfile`). Exits non-zero on any warning at the `warning` severity level or above.

Silencing warnings: add a `# shellcheck disable=SCXXXX` comment on the offending line, and include a brief reason:

```sh
# shellcheck disable=SC2086  # deliberately unquoted to trigger word-splitting
run $args
```

## Adding a new tool

Rule of thumb: if you find yourself typing the same 3+ commands to keep the repo tidy, wrap them in `tools/`.

Follow the repo conventions:

- `#!/usr/bin/env bash`
- `set -euo pipefail`
- A `usage()` function; exit 2 on misuse.
- Reference the repo root via `$(cd "$(dirname "$0")/.." && pwd)` — never assume the caller ran it from the repo root.
- Add a bats test if the tool has any real logic (`new-lesson.sh` would benefit from one).

## Ideas to add later

- `format-all.sh` — run `shfmt -w -i 4` across the tree.
- `check-links.sh` — verify every markdown link inside the repo resolves to a real path.
- `progress.sh` — parse `learn/INDEX.md` and print your completed vs remaining lessons.
- `render-cheatsheets.sh` — combine all `cheatsheets/*.md` into one printable PDF.
