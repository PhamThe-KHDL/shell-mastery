# zsh

Default interactive shell on macOS since 10.15. Mostly bash-compatible for scripting — but has enough differences to break scripts silently.

## Interactive superpowers over bash

- Better tab completion (context-aware, no `bash-completion` extra install).
- Autosuggestion (`zsh-autosuggestions`) and syntax highlight (`zsh-syntax-highlighting`) via plugin managers.
- Glob qualifiers: `ls *.log(.mh-1)` — regular files, modified in the last hour.
- Recursive glob `**/*.py` works with no extra flag.

## Common frameworks

- **oh-my-zsh** — big, batteries-included. Slower startup.
- **prezto** — modular, faster than oh-my-zsh.
- **zim** — minimal.
- **starship** — prompt only, portable across bash/zsh/fish.

Beginners: install oh-my-zsh, pick a theme (`robbyrussell` default is fine), then explore.

## Startup files

| File | When |
|---|---|
| `/etc/zshenv`, `~/.zshenv` | Always, first |
| `/etc/zprofile`, `~/.zprofile` | Login shell |
| `/etc/zshrc`, `~/.zshrc` | Interactive |
| `/etc/zlogin`, `~/.zlogin` | Login shell, after zshrc |
| `~/.zlogout` | Logout |

Put `PATH` and environment exports in `~/.zshenv`. Put aliases, prompt, plugins in `~/.zshrc`.

## Where zsh scripts break vs bash

| Feature | bash | zsh |
|---|---|---|
| Array index base | 0 | **1** |
| Word-splitting unquoted `$var` | yes | **no by default** |
| `[[ ]]` regex | `=~` with `BASH_REMATCH` | `=~` with `MATCH` / `match[]` |
| `read` array | `read -a` | `read -A` (uppercase) |
| Sourcing `~/.bashrc` | no-op mostly | won't set up completion |

**Do not `chmod +x` a `#!/bin/bash` script and expect it to work when someone `source`s it into zsh interactively.** The shebang controls execution when run directly; `source` runs in the current shell (whichever that is).

## Interactive tips

```sh
setopt AUTO_CD             # `documents` == `cd documents`
setopt AUTO_PUSHD          # every cd pushes to dirstack; `cd -1` back
setopt SHARE_HISTORY       # share history across all zsh sessions
setopt HIST_IGNORE_ALL_DUPS

bindkey -e                 # emacs keybinds (or bindkey -v for vi)
```

## References

- `man zshall`
- [zsh manual](https://zsh.sourceforge.io/Doc/Release/index.html)
