# 06 · Advanced — arrays, associative arrays, parameter expansion, coproc

## Goal

After this lesson you can:

- Use arrays and associative arrays correctly.
- Manipulate strings with parameter expansion (no `sed` for common ops).
- Understand `local -n` nameref for passing arrays into functions.
- Know when to reach for `coproc` — and when not to.
- Read regex with `=~` and back-references.

## 1. Arrays

```sh
files=(a.txt b.txt "c d.txt")
echo "${files[0]}"           # a.txt
echo "${files[@]}"           # a.txt b.txt c d.txt (each element = one arg)
echo "${#files[@]}"          # 3
files+=(e.txt)               # append
unset 'files[1]'             # remove index 1 (leaves a gap!)

# Iterate
for f in "${files[@]}"; do echo "$f"; done

# Read into an array (bash 4+):
mapfile -t lines < file.txt
readarray -t lines < file.txt    # alias

# Read from a command
mapfile -t hosts < <(cut -d, -f1 hosts.csv)

# Slice
echo "${files[@]:1:2}"       # 2 elements starting from index 1
```

Always quote `"${arr[@]}"` — unquoted it word-splits and glob-expands.

## 2. Associative arrays (bash 4+)

```sh
declare -A user
user[name]=alice
user[email]=alice@example.com

echo "${user[name]}"
echo "${!user[@]}"           # keys
echo "${user[@]}"            # values

# Check key existence
[[ -v user[name] ]] && echo "has name"
```

macOS default bash is 3.2 — no associative arrays. Install bash 4+: `brew install bash`, then use `#!/usr/bin/env bash` (assumes bash on `$PATH` is the new one).

## 3. Parameter expansion — string ops without sed

```sh
name="hello_world.tar.gz"

echo "${name%.gz}"           # hello_world.tar   (remove shortest suffix match)
echo "${name%%.*}"           # hello_world       (remove longest suffix from first .)
echo "${name#hello_}"        # world.tar.gz      (remove shortest prefix)
echo "${name##*/}"           # basename equivalent
echo "${name%/*}"            # dirname equivalent

echo "${name/world/earth}"   # hello_earth.tar.gz  (replace first)
echo "${name//_/-}"          # hello-world.tar.gz  (replace all)

echo "${#name}"              # length
echo "${name:6:5}"           # substring: start=6, len=5

echo "${name:-default}"      # use default if unset/empty
echo "${name:=default}"      # assign default if unset/empty
echo "${name:+alt}"          # use "alt" IF name is set
echo "${name:?err}"          # error if unset
```

Faster than spawning `sed`/`cut` in a loop.

## 4. Nameref — arrays into functions

```sh
push() {
    local -n arr=$1        # arr is now a reference to the caller's array
    shift
    arr+=("$@")
}

items=(a b)
push items c d e
declare -p items           # items=([0]="a" [1]="b" [2]="c" [3]="d" [4]="e")
```

Requires bash 4.3+. Before nameref, people passed arrays by expanding to `"${arr[@]}"` and rebuilding inside — awkward and lossy for empty elements.

## 5. Regex with `=~`

```sh
s="user@example.com"
if [[ $s =~ ^([^@]+)@(.+)$ ]]; then
    echo "user=${BASH_REMATCH[1]} host=${BASH_REMATCH[2]}"
fi
```

Do not quote the regex on the right side — quoting turns it into a literal string in bash.

## 6. `coproc` — bidirectional child

```sh
coproc BC { bc; }
echo "1+1" >&"${BC[1]}"
read -r result <&"${BC[0]}"
echo "$result"
kill "$BC_PID"
```

Rarely the right tool — usually you can pipe. Reach for `coproc` when you must send multiple inputs and read multiple outputs from the same process (interactive tools, session-oriented protocols). For everything else, a temp file or two pipes are simpler.

## 7. When to leave shell

You are past the shell's comfort zone when:

- You have nested data structures (a map of arrays of maps).
- You need proper error types or exceptions.
- You're doing math beyond integers.
- Performance matters (looping millions of items).

At that point: Python, Go, or a proper language. `awk` still fills a niche between shell and Python.

## Further reading

- [cheatsheets/arrays.md](../../../cheatsheets/arrays.md)
- [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md)
