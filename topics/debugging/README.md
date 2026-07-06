# Topic · Debugging shell scripts

Shell debugging is 80% "print the right thing at the right moment", 20% "read the manual again". No IDE debugger, no breakpoints — just tracing and thinking.

The tools below cost nothing and take one minute to learn. Learn all of them; each shines in different situations.

## Debugging mindset

Before any tool, ask three questions:

1. **What did I expect?** Say it out loud in one sentence.
2. **What actually happened?** Read the output; don't skim.
3. **What's the smallest change that would prove where they diverge?**

Print statements, not guesses. Bash rewards patience.

## 1. `bash -n` — syntax check without running

```sh
bash -n script.sh
```

Runs the parser but not the code. Catches missing `fi`, `done`, unterminated quotes. Cheap first pass whenever you see a `syntax error` at execution time — it may point at a nested problem the runtime error misses.

Downside: doesn't catch runtime issues like unbound variables.

## 2. `bash -x` — trace every command

```sh
bash -x script.sh
```

Prints every command **after expansion**, prefixed with `+`. You see the actual values, not the source text — invaluable when you don't understand why an `if` branch fired.

```
$ cat greet.sh
name="alice"
if [[ $name == a* ]]; then echo "hi $name"; fi

$ bash -x greet.sh
+ name=alice
+ [[ alice == a* ]]
+ echo 'hi alice'
hi alice
```

Enable temporarily inside a script:
```sh
set -x                      # start tracing
# ... suspect section ...
set +x                      # stop tracing
```

## 3. Better `PS4` — richer trace format

The default `+ ` prefix is boring. Redefine `PS4` to include file, line, and function:

```sh
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x script.sh
```

Now each trace line looks like:
```
+ greet.sh:3:main: [[ alice == a* ]]
+ greet.sh:3:main: echo 'hi alice'
```

Instant pinpoint for large scripts.

## 4. `set -v` — print each line as read

```sh
set -v
```

Different from `-x`: prints the **source** of each line before executing (no expansion). Useful when you want to see the script as it flows through here-docs and loops, without expansion noise.

## 5. `trap ERR` — see what died

Under `set -e`, any command that returns non-zero terminates the script — but bash by default doesn't tell you WHICH command:

```sh
$ bash -e broken.sh
$ echo $?
1
```

Add:
```sh
trap 'echo "ERR at line $LINENO: $BASH_COMMAND (exit $?)" >&2' ERR
```

Now the failing script says:
```
ERR at line 42: rm -rf "$missing_dir" (exit 1)
```

Cheap postmortem. Combine with `set -euo pipefail` and this trap in every real script.

## 6. `trap DEBUG` — hook before every command

Fires before **every** command, not just failing ones. Use for structured logging without cluttering the code:

```sh
trap 'printf "→ %s\n" "$BASH_COMMAND" >&2' DEBUG
```

Similar to `set -x` but you control the format — timestamp, level, whatever.

## 7. Piping output while keeping stdout usable

Sometimes a script's output is data you're piping elsewhere, and you also want to see logs. `tee` splits it:

```sh
# At the top of your script:
exec > >(tee -a run.log) 2>&1
```

Now everything the script writes goes to both `run.log` and the terminal. The trailing `2>&1` sends stderr through the same pipe.

## 8. Interactive `read` breakpoint

Add a manual pause anywhere:

```sh
echo "state at line $LINENO: count=$count"
read -r -p "press enter to continue... "
```

Useful when you don't need a full debugger but want to poke at variables between phases.

## 9. `bashdb` — a real debugger

If tracing isn't enough, https://bashdb.sourceforge.net/ provides gdb-style breakpoints, stepping, and inspection. Rarely worth setting up — 95% of bugs surrender to `set -x` — but keep it in mind for genuinely tangled scripts.

## Common symptoms → likely causes

| Symptom | Likely cause | Where to read |
|---|---|---|
| "Works in my terminal, fails in cron" | Different `$PATH`, `.bashrc` not sourced, non-interactive shell | This page + `man bash` on `LOGIN SHELL` |
| "Command not found" only in script | Missing shebang, not executable, or PATH lacks the tool | `chmod +x`, `#!/usr/bin/env bash` |
| "unbound variable" | `set -u` fired — typo or missing default | Add `${var:-default}` or check spelling |
| Loop counts to 5 but ends at 0 | The loop ran in a subshell (right of a pipe) | [learn/04-io-and-processes](../../learn/04-io-and-processes/en/notes.md) |
| Argument with space became 2 args | Missing quotes on `$var` or `${arr[@]}` | [topics/quoting](../quoting/README.md) |
| `cd` in script doesn't change caller dir | `cd` runs in the child process | Use `source script.sh` or an alias |
| Script hangs forever | Blocking on stdin somewhere (missing `< /dev/null`?) or waiting for a child | Try `bash -x`, look for `read` or `wait` |
| `set -e` didn't exit on failure | Command was in an `if`, `while`, or `\|\|` context — `-e` skips those | [learn/05-robust-scripts](../../learn/05-robust-scripts/en/notes.md) |

## Debugging checklist for any weird bash bug

1. Run `shellcheck` — often the fastest fix.
2. Run with `bash -x` (or `set -x` around the suspect block).
3. Add `trap 'echo "ERR at $LINENO: $BASH_COMMAND"' ERR`.
4. Verify quoting on every `$var` in the region.
5. If a variable "changed on its own", check for a subshell.
6. Reproduce with the minimum input possible.
7. If stuck for 30 minutes, explain it to a colleague. Half the time you catch it while explaining.

## Cross-reference

- [topics/shellcheck](../shellcheck/README.md) — catch bugs before running.
- [topics/quoting](../quoting/README.md) — cures 40% of "why is it broken?".
- [learn/05-robust-scripts](../../learn/05-robust-scripts/en/notes.md) — strict mode and traps in context.
