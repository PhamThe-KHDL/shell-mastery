# 03 · Scripting fundamentals — variables, if, loops, functions, exit codes

## Goal

After this lesson you can:

- Declare variables correctly (local vs global, quoting on assignment).
- Write `if`, `case`, `for`, `while` — and know when to use each.
- Write functions with local variables and proper return codes.
- Read exit codes and use `&&`/`||` for control flow.
- Read arguments and handle flags with `getopts`.

## 1. Variables

```sh
name=alice              # no spaces around =
name="Alice Smith"      # quotes for strings with spaces
count=$((1 + 2))        # arithmetic
today=$(date +%F)       # command substitution
readonly VERSION=1.0    # can't reassign
unset name              # remove
```

Only `export` a variable if a **child process** needs to read it. Otherwise leave it local to the script.

```sh
export PATH="$HOME/bin:$PATH"    # child processes inherit
tmp="$(mktemp)"                  # local, not exported
```

Default values:

```sh
name="${1:-world}"          # use $1, else "world"
: "${API_URL:?must be set}" # exit if unset (guard at script top)
```

## 2. `if` and `[[ ]]`

```sh
if [[ -f "$file" ]]; then
    echo "file exists"
elif [[ -d "$file" ]]; then
    echo "directory"
else
    echo "not found"
fi
```

Prefer `[[ ]]` in bash — safer than `[ ]` (no word-splitting inside, supports `&&`/`||`, pattern matching with `==` and regex with `=~`).

Common tests:

| Test | Meaning |
|---|---|
| `-f file` | regular file |
| `-d file` | directory |
| `-e file` | exists |
| `-r/-w/-x file` | readable/writable/executable |
| `-z str` | string is empty |
| `-n str` | string is non-empty |
| `str1 == str2` | equal |
| `str =~ regex` | regex match (bash) |
| `n -eq/-ne/-lt/-gt` | integer compare |

## 3. `case`

```sh
case "$1" in
    start)  systemctl start app ;;
    stop)   systemctl stop app ;;
    reload) systemctl reload app ;;
    *)      echo "unknown"; exit 2 ;;
esac
```

Cleaner than a chain of `elif` when comparing against fixed strings or glob patterns.

## 4. Loops

```sh
for f in *.log; do
    gzip "$f"
done

for i in {1..5}; do
    echo "$i"
done

for i in $(seq 1 5); do        # common, but not POSIX
    echo "$i"
done

while read -r line; do
    process "$line"
done < input.txt

while true; do
    check_something && break
    sleep 5
done
```

Reading a file line by line: **always** use `while read -r`, never `for line in $(cat file)` — the latter word-splits and glob-expands.

`seq` is widely available, but it is not a POSIX requirement. If you need maximum portability, prefer a `while` loop with an integer counter.

## 5. Functions

```sh
say_hello() {
    local name=${1:-world}
    echo "hello, $name"
}

say_hello alice
```

Rules:
- Declare arguments as `local` inside — otherwise they leak into the caller's scope.
- Return a value via `echo` (captured with `$(...)`) or set an exit code with `return 0..255`.
- Do not `exit` inside a function that's called for its return value — you'll kill the whole script.

## 6. Exit codes and control flow

```sh
cmd && echo "ok"          # run 2nd only if 1st succeeds (exit 0)
cmd || echo "failed"      # run 2nd only if 1st fails
cmd1 && cmd2 || cmd3      # careful: cmd3 runs if cmd1 OR cmd2 fails
```

Exit code convention:
- `0` = success.
- `1` = generic error.
- `2` = misuse (bad arguments).
- `126`, `127`, `130` = reserved (permission, not found, Ctrl-C).

Get the last exit code with `$?` (only immediately after — it's clobbered by the next command).

## 7. `getopts` — parsing flags

```sh
usage() { echo "Usage: $0 [-v] [-o file] input" >&2; exit 2; }

verbose=0
output=/dev/stdout
while getopts ":vo:h" opt; do
    case $opt in
        v) verbose=1 ;;
        o) output=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ge 1 ]] || usage
input=$1
```

`getopts` is built into bash — no external dependency. Good enough for 90% of scripts. For long options (`--verbose`), use a manual parser (see [snippets/argparse.sh](../../../snippets/argparse.sh)).

## Further reading

- [topics/quoting](../../../topics/quoting/README.md)
- [snippets/getopts.sh](../../../snippets/getopts.sh)
