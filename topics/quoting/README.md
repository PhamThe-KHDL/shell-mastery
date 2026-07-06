# Topic · Quoting & word splitting

The **#1 source of shell bugs**. If you learn only one advanced shell topic, learn this. Once quoting clicks, half the "why did my script do that?!" moments disappear.

## Why quoting matters — a 30-second demo

```sh
$ file="my important file.txt"
$ ls -l $file
ls: cannot access 'my': No such file or directory
ls: cannot access 'important': No such file or directory
ls: cannot access 'file.txt': No such file or directory

$ ls -l "$file"
-rw-r--r-- 1 me me 42 Oct 15 10:00 'my important file.txt'
```

The unquoted expansion was split into **three arguments** by the shell before `ls` ever ran. Quoting kept it as one.

This kind of bug is invisible until it fires — and it fires on filenames from users, timestamps with spaces, environment variables that were "usually empty", and shell commands you copy from Stack Overflow.

## The golden rule

> **Always `"$var"` and `"${arr[@]}"` unless you deliberately want word splitting or glob expansion.**

You'll break this rule on purpose in maybe 5% of cases (e.g. splitting a colon-delimited `$PATH` on `:` by manipulating `IFS`). The other 95% of the time, quote.

## What actually happens when you write `$var`

After the shell expands a variable, it performs three operations **in order**:

1. **Word splitting** — the expanded value is split on each character in `$IFS`. The default `IFS` is space + tab + newline, so `"a b c"` becomes three "words".
2. **Pathname expansion** (globbing) — each word is checked against filenames. `*` matches everything, `?` matches one char, `[abc]` matches one of `a`, `b`, or `c`.
3. **Argument passing** — the resulting words are passed as separate arguments to the command.

```sh
files="a.txt b.txt"

rm $files          # after expansion: rm a.txt b.txt   → 2 args
rm "$files"        # after expansion: rm "a.txt b.txt" → 1 arg
```

Both can be correct. The **decision** must be yours; it must never be an accident.

## Reference table

| Form | Word split? | Glob? | Expand `$var`? | Expand `$(...)`? |
|---|:-:|:-:|:-:|:-:|
| `$var`             | ✅ | ✅ | ✅ | — |
| `"$var"`           | ❌ | ❌ | ✅ | ✅ |
| `'$var'`           | ❌ | ❌ | ❌ | ❌ |
| `${arr[*]}`        | ✅ | ✅ | ✅ | — |
| `"${arr[*]}"`      | ❌ | ❌ | joined into one string | — |
| `${arr[@]}`        | ✅ | ✅ | ✅ | — |
| `"${arr[@]}"`      | ❌ | ❌ | **one arg per element** | — |
| `\$var`            | — | — | ❌ (escaped $) | — |

`"${arr[@]}"` is what you want almost every time you iterate an array.

## Common pitfalls (with fixes)

### 1. Files with spaces from `$(ls)` or `find`

```sh
# ❌ breaks on filenames with spaces
for f in $(ls); do process "$f"; done

# ✅ globs preserve the whole name
for f in *; do process "$f"; done

# ✅ use find + NUL delimiter for non-cwd cases
find . -type f -print0 | while IFS= read -r -d '' f; do
    process "$f"
done
```

### 2. Empty arguments silently disappearing

```sh
# ❌ if $empty is unset, this becomes: mycmd other
mycmd $empty other

# ✅ preserves the empty slot
mycmd "$empty" other
```

Real bug this causes: passing an empty `--flag` value shifts positional arguments, so `mycmd --file "" input.txt` becomes `mycmd --file input.txt` — silently reading the wrong file.

### 3. String tests failing on empty variables

```sh
$ var=
$ [ $var = foo ]     # → [: =: unary operator expected
$ [ "$var" = foo ]   # ✅ tests empty string against "foo"
$ [[ $var = foo ]]   # ✅ [[ ]] doesn't word-split, so this works
```

`[[ ]]` is quoting-friendly; `[ ]` is not.

### 4. Assigning without quotes usually works — but not always

```sh
name=$other        # OK even with spaces in $other — assignment doesn't word-split
export A=$other    # ALSO OK

# But:
declare A=$other   # ⚠ subject to word splitting on some bash versions
                   # → declare A="$other"
```

Assignment on its own line doesn't need quoting, but be defensive anyway — habit protects you when you later refactor into a function argument or command.

### 5. Regex in `[[ =~ ]]`

```sh
# ❌ quotes turn the regex into a literal string in bash
[[ $email =~ "^[a-z]+@" ]]

# ✅ leave the regex bare
[[ $email =~ ^[a-z]+@ ]]

# ✅ or put it in a variable and use unquoted
regex='^[a-z]+@'
[[ $email =~ $regex ]]
```

## When you WANT word splitting

Legitimate cases exist:

```sh
# Split a colon-delimited path into loop iterations
IFS=: read -ra parts <<< "$PATH"
for p in "${parts[@]}"; do echo "$p"; done

# Command-line flag composition — deliberate splitting
common_args="--verbose --color=always"
grep $common_args pattern file    # deliberate; add shellcheck disable=SC2086
```

When you do it on purpose, add a `# shellcheck disable=SC2086` comment explaining why. That prevents the linter from complaining AND documents intent for the next reader.

## Recap in one paragraph

Every unquoted `$var` invites the shell to split on whitespace and expand globs. That's rarely what you want, and it produces bugs that only fire on specific inputs. Default to `"$var"`. Default to `"${arr[@]}"`. Use `[[ ]]` instead of `[ ]` when writing bash. Use `# shellcheck disable=SC2086` with a comment when you break the rule on purpose.

## Cross-reference

- [learn/01-basics](../../learn/01-basics/en/notes.md) — first introduction.
- [topics/shellcheck](../shellcheck/README.md) — SC2086 catches unquoted expansions automatically.
- [cheatsheets/test.md](../../cheatsheets/test.md) — `[ ]` vs `[[ ]]` at a glance.
