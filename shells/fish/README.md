# fish

Friendly interactive shell. Its syntax is **not POSIX**, so you can't share scripts with bash/zsh users.

## Why people love it (interactive)

- Autosuggestions from history — no config.
- Syntax highlighting built in.
- Web-based config: `fish_config`.
- Fewer footguns than bash for new users.

## Why it hurts (scripts)

- No POSIX. Every reference on Stack Overflow assumes bash.
- Sharing scripts with a team means either "everyone install fish" or "rewrite in bash". Almost always the second.

Common recommendation: **fish for daily typing, bash for scripts**. Set your login shell to fish, but write executables with `#!/usr/bin/env bash`.

## Syntax differences

| Task | bash | fish |
|---|---|---|
| Variable set | `x=1` | `set x 1` |
| Export | `export X=1` | `set -x X 1` |
| Command sub | `$(cmd)` | `(cmd)` |
| Conditional | `if [[ ]]; then ... fi` | `if test ...; ...; end` |
| Loop | `for x in a b; do ...; done` | `for x in a b; ...; end` |
| Function | `f() { ... }` | `function f; ...; end` |
| Alias | `alias ll='ls -la'` | `alias ll 'ls -la'` (or `function ll`) |

Fish's variables are lists, not scalars. `set files a.txt b.txt` makes `$files` a 2-element list; expansion is element-wise like `"${arr[@]}"` in bash.

## Config

- `~/.config/fish/config.fish` — main config.
- `~/.config/fish/functions/` — one file per function, autoloaded.
- `~/.config/fish/completions/` — completions.
- Universal variables (persist across sessions): `set -U`.

## Migrating from bash

- Aliases mostly work with `alias`.
- `$PATH` — use `fish_add_path /some/dir` (persistent) or `set -gx PATH /some/dir $PATH`.
- Dotfile: your `~/.bashrc` won't be sourced; port carefully.

## References

- [fish docs](https://fishshell.com/docs/current/)
