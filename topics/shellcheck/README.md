# Topic · shellcheck

Static analyzer for shell scripts. Run it on everything. It catches most of the mistakes this repo teaches you to avoid — before you even run the script.

If you install one tool from this whole repo, install shellcheck.

## Why bother

Bash's error messages are legendary for their unhelpfulness. Consider:

```sh
$ ./script.sh
./script.sh: line 12: syntax error near unexpected token `done'
```

That's it. No pointer to what's actually wrong. Meanwhile:

```sh
$ shellcheck script.sh

In script.sh line 8:
    if [ $count -gt 0 ]
       ^-- SC1073 (error): Couldn't parse this test expression.
                          Fix to allow more checks.

In script.sh line 8:
    if [ $count -gt 0 ]
                       ^-- SC1009 (error): The mentioned syntax error was in this if expression.
```

shellcheck points at the exact character, explains the code, and links to a wiki page with fixes. Its warnings distill decades of shell folklore into machine-readable form.

## Install

```sh
brew install shellcheck                     # macOS
sudo apt install shellcheck                 # Debian/Ubuntu
sudo pacman -S shellcheck                   # Arch
```

Verify:
```sh
shellcheck --version
```

Or try it in the browser: https://www.shellcheck.net/

## Basic usage

```sh
shellcheck script.sh                        # scan one file
shellcheck script1.sh script2.sh            # multiple files
shellcheck -x script.sh                     # follow `source` and `.` directives
shellcheck --severity=warning script.sh     # ignore style-level notes
shellcheck --shell=bash script.sh           # force shell dialect (bash/sh/dash/ksh)
```

Severity levels, from strictest to noisiest:
- `error` — code that's almost certainly broken.
- `warning` — very likely a bug. **This repo's baseline.**
- `info` — might be a bug depending on intent.
- `style` — nitpicks; ignore unless your team enforces them.

Everything at or above the chosen severity is reported.

## Editor integration

Real-time squiggles beat batch runs. Set this up once and forget:

- **VS Code**: install `timonwong.shellcheck`. Works out of the box if `shellcheck` is on `$PATH`.
- **Neovim**: use `nvim-lspconfig` with `bashls` — bashls calls shellcheck under the hood.
- **Vim**: use ALE (`w0rp/ale`) with `let g:ale_linters = {'sh': ['shellcheck']}`.
- **JetBrains IDEs**: built-in. Settings → Editor → Inspections → Shell Script → enable shellcheck.
- **Sublime Text**: install the `SublimeLinter-shellcheck` package.

## CI integration

This repo's [`.github/workflows/build.yml`](../../.github/workflows/build.yml) runs shellcheck on every push. Copy the pattern:

```yaml
- name: Install shellcheck
  run: sudo apt-get install -y shellcheck
- name: Run shellcheck
  run: find . -name '*.sh' -exec shellcheck --severity=warning {} +
```

Also see [`tools/lint-all.sh`](../../tools/lint-all.sh) for a self-contained runner.

## Silencing warnings

Only silence when you understand why. Never blanket-disable.

**Per-line disable, with a reason:**
```sh
# shellcheck disable=SC2086  # deliberately unquoted to invoke word splitting
run $args
```

**Per-file disable (top of file):**
```sh
#!/usr/bin/env bash
# shellcheck disable=SC1091
```

**Repo-wide disable:** create a `.shellcheckrc`:
```
disable=SC1091
```

Prefer a per-line comment. A directive without a comment is a smell — the next reader can't tell why it's there. If a directive persists for months without a fix, treat it as a design bug: shellcheck was probably right.

## The 10 warnings you'll actually see

| Code | Meaning | Typical fix |
|---|---|---|
| SC2086 | Unquoted variable → word split | `"$var"` |
| SC2068 | Unquoted `$@`/`${arr[@]}` | `"$@"` / `"${arr[@]}"` |
| SC2155 | `local x=$(cmd)` masks cmd's exit code | Split: `local x; x=$(cmd)` |
| SC2164 | `cd` result unchecked | `cd foo \|\| exit` |
| SC1091 | Can't follow `source` | `# shellcheck source=./lib.sh` |
| SC2015 | `A && B \|\| C` isn't if/else | Use real `if`/`then`/`else` |
| SC2181 | Checking `$?` right after a command | Use `if cmd; then ...` |
| SC2046 | Unquoted `$(...)` | `"$(...)"` |
| SC2001 | Using sed for a substitution that parameter expansion does | `${var/old/new}` |
| SC2001 (dup) | See above | Same fix |

Full wiki, one page per code: https://www.shellcheck.net/wiki/

## A worked example

Before:
```sh
#!/bin/bash
count=`ls *.log | wc -l`
if [ $count -gt 5 ]; then
    for f in $(ls *.log); do
        cat $f
    done
fi
```

shellcheck output (paraphrased):
- SC2006 — use `$(...)` not backticks.
- SC2086 — quote `$count` in the test.
- SC2045 — don't iterate the output of `ls`.
- SC2086 — quote `$f`.

After:
```sh
#!/usr/bin/env bash
set -euo pipefail

count=$(find . -maxdepth 1 -name '*.log' | wc -l)
if [[ $count -gt 5 ]]; then
    for f in *.log; do
        cat "$f"
    done
fi
```

Cleaner, safer, and shellcheck-clean. This is the loop: write, lint, fix, repeat. Over a few weeks the muscle memory internalizes, and shellcheck becomes a safety net rather than a teacher.

## Cross-reference

- [tools/lint-all.sh](../../tools/lint-all.sh) — repo-wide runner.
- [topics/quoting](../quoting/README.md) — what most shellcheck warnings are actually about.
