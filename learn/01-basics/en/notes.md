# 01 · Basics — navigation, pipes, redirect, quoting

## Goal

After this lesson you can:

- Move around the filesystem without guessing.
- Understand the three standard streams (stdin/stdout/stderr) and combine them with pipes and redirects.
- Quote correctly — the #1 source of shell bugs.

## 1. Navigation

```sh
pwd                    # where am I
cd -                   # jump back to the previous dir
cd                     # go to $HOME
ls -lah                # long, all, human-readable
```

## 2. The three standard streams

| FD | Name | Default |
|----|------|---------|
| 0 | stdin | keyboard |
| 1 | stdout | terminal |
| 2 | stderr | terminal |

```sh
cmd > out.txt          # stdout → file (overwrite)
cmd >> out.txt         # stdout → file (append)
cmd 2> err.txt         # stderr → file
cmd > out 2>&1         # merge both into out
cmd &> out             # bash shortcut for the above
cmd < in.txt           # read stdin from a file
```

Classic pitfall: `cmd 2>&1 > out` does **not** send stderr to the file. Redirects are processed left-to-right; when `2>&1` runs, stdout is still the terminal. Correct order: `cmd > out 2>&1`.

## 3. Pipes

```sh
ps aux | grep nginx | awk '{print $2}'
```

A pipe wires the stdout of the left command into the stdin of the right. In normal bash usage, each pipeline component runs in its own subshell, so variables assigned inside a pipe do not persist after it. Lesson 04 covers the `lastpipe` exception.

## 4. Quoting — the important part

| Form | Example | Expand vars? | Expand `$(...)`? | Preserve whitespace? |
|---|---|---|---|---|
| unquoted | `$var` | ✅ | ✅ | ❌ (word split) |
| single quotes `'...'` | `'$var'` | ❌ | ❌ | ✅ |
| double quotes `"..."` | `"$var"` | ✅ | ✅ | ✅ |

**Golden rule**: always `"$var"` unless you deliberately want word splitting.

```sh
file="my file.txt"
rm $file           # ❌ runs `rm my file.txt` — deletes 2 files
rm "$file"         # ✅
```

## 5. Globbing

```sh
ls *.md            # every .md file in cwd
ls **/*.md         # recursive (requires `shopt -s globstar` in bash)
ls file?.txt       # a single arbitrary character
ls [ab]*.txt       # starts with a or b
```

Globs are expanded by the shell **before** the command sees the arguments. If a glob matches nothing, bash leaves the literal string in place by default (trap!). Enable `shopt -s failglob` to make it fail loudly instead.

## Further reading

- [topics/quoting](../../../topics/quoting/en/README.md) — deeper dive into `$IFS` and word splitting.
- `man bash` section `REDIRECTION`.
