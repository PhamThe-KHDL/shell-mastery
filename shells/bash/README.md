# bash

The default scripting target of this repo. Ubiquitous on Linux, installable everywhere.

## Version matters

- **3.2** — macOS default. Frozen in 2007. No associative arrays, no `mapfile`, no `${var,,}` case conversion, no nameref.
- **4.0** — associative arrays, `mapfile`/`readarray`, `${var,,}`/`${var^^}`, `coproc`.
- **4.3** — `local -n` nameref, negative array indices.
- **4.4** — `${parameter@Q}` quoting operator, `mapfile -d` (custom delimiter).
- **5.x** — mostly bugfixes; not a big syntactic step from 4.

Rule of thumb: **write for bash 4+**. Ask users to install `brew install bash` on macOS if needed.

## Startup files (interactive)

| File | When |
|---|---|
| `/etc/profile`, `/etc/bash.bashrc` | System-wide |
| `~/.bash_profile` / `~/.profile` / `~/.bash_login` | Login shell |
| `~/.bashrc` | Interactive non-login shell |
| `~/.bash_logout` | On logout |

macOS Terminal starts login shells, so `~/.bashrc` is NOT sourced by default. Common fix in `~/.bash_profile`:
```sh
[[ -f ~/.bashrc ]] && . ~/.bashrc
```

## Useful runtime toggles

```sh
shopt -s globstar         # ** matches recursively
shopt -s nullglob         # unmatched globs → empty (not literal)
shopt -s failglob         # unmatched globs → error (safer for scripts)
shopt -s extglob          # extended patterns: @(a|b), !(x), +(x)
shopt -s inherit_errexit  # subshells inherit set -e (bash 4.4+)
set -o vi                 # vi keybindings on the command line
```

## Prompt (interactive)

```sh
PS1='\u@\h \w \$ '
```

`\u` user, `\h` host, `\w` cwd, `\$` `$` (or `#` for root).

For fancy prompts (git branch, exit code color): consider `starship` or `oh-my-bash` — but a plain PS1 is enough for years.

## Debugging

See [topics/debugging](../../topics/debugging/en/README.md).

## References

- `man bash`
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
