# 05 · Robust scripts — `set -euo pipefail`, IFS, error handling

## Goal

After this lesson you can:

- Write scripts that fail loudly instead of silently corrupting data.
- Understand exactly what `set -e`, `-u`, `-o pipefail` do — and their gotchas.
- Trap errors and produce useful diagnostics.
- Validate inputs at the boundary.

## 1. The strict-mode header

Start every script with:

```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

- `-e` — exit on error (any command returning non-zero terminates the script).
- `-u` — treat unset variables as errors.
- `-o pipefail` — a pipeline fails if **any** stage fails, not just the last one.
- `IFS=$'\n\t'` — split words on newline and tab only, not on spaces. Reduces surprise from unquoted expansion.

## 2. `set -e` gotchas

`set -e` is helpful but not magic. It does **not** trigger when:

```sh
# Inside if/while/until conditions
if broken_cmd; then ...           # broken_cmd's failure is fine here

# Left of && or ||
broken_cmd && next                # broken_cmd fails silently

# Inside a function called with $() when the caller only checks $()
```

Do not rely on `set -e` for critical error checks. Use explicit `|| { ... }` or `if`.

## 3. `set -u` and defaults

```sh
echo "$name"                # error if unset
echo "${name:-default}"     # use default if unset (does not trigger -u)
echo "${name:?must be set}" # exit with message if unset
```

Guard early:
```sh
: "${API_URL:?}" "${API_KEY:?}"
```

## 4. `set -o pipefail`

```sh
grep foo huge.log | head -1     # without pipefail: exit 0 even if grep dies
```
With `pipefail`, if `grep` dies (e.g. file missing), the whole pipeline exits non-zero. This is what you almost always want.

## 5. `trap ERR` — see what died

```sh
trap 'echo "ERR at line $LINENO: $BASH_COMMAND" >&2' ERR
```

Prints the failing command and line number. Cheap, invaluable for debugging.

## 6. Input validation

Bad scripts trust inputs. Good scripts fail fast at the boundary.

```sh
usage() { echo "Usage: $0 <input> <output>" >&2; exit 2; }

[[ $# -eq 2 ]] || usage
input=$1
output=$2

[[ -r $input ]]  || { echo "cannot read $input" >&2; exit 1; }
[[ ! -e $output || -w $output ]] || { echo "cannot write $output" >&2; exit 1; }
```

## 7. Atomic writes

Never write directly to the destination — write to a temp file and `mv` at the end. `mv` on the same filesystem is atomic.

```sh
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

produce_output > "$tmp"
mv "$tmp" "$destination"
trap - EXIT     # cancel cleanup — the file is now in its final place
```

## 8. The full template

```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

: "${API_URL:?}"

trap 'echo "ERR at line $LINENO: $BASH_COMMAND" >&2' ERR

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

usage() { echo "Usage: $0 ..." >&2; exit 2; }
[[ $# -ge 1 ]] || usage

# ... actual work ...
```

## Further reading

- [topics/debugging](../../../topics/debugging/README.md)
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)
