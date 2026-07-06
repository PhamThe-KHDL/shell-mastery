# shells

The Unix world has many shells. They fall into three groups:

- **Bourne-family** (bash, zsh, ksh) — mostly cross-compatible scripting syntax.
- **POSIX-strict** (dash, ash, busybox sh, POSIX-mode bash) — the lowest common denominator.
- **Non-POSIX** (fish, nushell) — different syntax; scripts don't port.

This directory compares them for two audiences:

- **You're choosing an interactive shell** for daily typing.
- **You're deciding what to target** when writing scripts.

## Available comparisons

| Shell | Read if | Interactive strengths | Scripting story |
|---|---|---|---|
| [`bash/`](bash/)          | You want the default target | Universal, familiar | The main scripting language of this repo |
| [`zsh/`](zsh/)            | You use macOS (default since 10.15) | Rich completion, glob qualifiers, plugin ecosystem | Mostly bash-compatible, subtle traps exist |
| [`fish/`](fish/)          | You want the friendliest interactive shell | Autosuggestions, syntax highlight, no config needed | Not POSIX; scripts don't port |
| [`posix-sh/`](posix-sh/)  | You target Alpine / BusyBox / installers | Not for interactive use | The most portable scripting choice |

## Quick decision guide

**"What shell should I write scripts in?"**

- Default answer: **bash 4+**. Most tutorials assume it, shellcheck knows it best, and it's available everywhere with an install.
- If your script ships to end-users you don't control (`curl \| sh`): **POSIX sh**, tested in Alpine.
- If your script targets one system whose shell you control (a specific server, a Docker image): **whatever that system has**.

**"What shell should I use interactively?"**

- Whatever you find pleasant. Zsh with oh-my-zsh is a common default. Fish is friendlier for newcomers. Bash is fine — the defaults are just spartan.
- Common setup: **fish or zsh for interactive, bash for scripts.**

## When this folder matters during the course

Most learners can ignore `shells/` until one of these happens:

- you are on macOS and wonder why interactive zsh differs from bash scripts
- you hit a feature that exists in bash 4+ but not in `/bin/bash` 3.2
- you need a script to run under `sh` on Alpine or BusyBox

If none of those are true yet, stay in `learn/` and come back later.

## The critical rule

**Setting your login shell to X doesn't change what scripts do.** A script with `#!/usr/bin/env bash` always runs in bash, regardless of your login shell. Confusingly, `source script.sh` runs in your current interactive shell — which is why sourcing bash-only code from zsh sometimes fails.

That single rule explains a huge amount of beginner confusion. Many "but it worked in my terminal" bugs are really "I tested it in zsh and then ran it as bash" bugs.

## Version awareness matters

- **bash 3.2** — macOS default. Missing `mapfile`, associative arrays, `${var,,}`.
- **bash 4.0** — associative arrays, `mapfile`, case conversions.
- **bash 4.3** — `local -n` nameref.
- **bash 4.4** — `${x@Q}` quoting.
- **bash 5.x** — bug fixes; nothing new to lose sleep over.

- **zsh 5** — current major version everywhere.
- **fish 3+** — current everywhere.
- **dash** — extremely stable, tracks POSIX.

Check with `<shell> --version` before assuming.

## For deep-dives, see the shell's own manual

- `man bash`
- `man zshall` (or `zshall`; `man zsh` is shorter)
- `man fish` (or `fish --help`)
- `man dash`
- POSIX spec: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
