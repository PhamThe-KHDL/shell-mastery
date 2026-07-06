# POSIX sh

The lowest common denominator. On Alpine and BusyBox `/bin/sh` is `ash`; on Debian it's `dash`; on macOS it's actually bash in POSIX mode. All lack most of the bash niceties you love.

## When to write POSIX sh

- Init/service scripts on containers.
- Portable installers (`curl ... | sh`).
- Anywhere you cannot guarantee bash's presence.

Otherwise write bash. POSIX-only is a real cost.

## Things you don't have

- Arrays.
- `[[ ]]` — use `[ ]` (and quote everything!).
- `local` — technically not POSIX, though every real sh supports it. Alpine ash, dash, and bash all have it.
- Process substitution `<(cmd)`, `>(cmd)`.
- `$RANDOM`, `$SECONDS`.
- Array parameter expansion.
- Extended parameter expansion `${var,,}`, `${var^^}`.
- Regex `=~`.
- `mapfile`/`readarray`.
- Brace expansion `{1..5}`.

## Idioms

### Array replacement — positional params
```sh
set -- one two three "four five"
for arg in "$@"; do
    echo "$arg"
done
```

### Substring — use `expr` or `cut`
```sh
s="hello world"
# first 5 chars
expr substr "$s" 1 5
echo "$s" | cut -c1-5
```

### Uppercase
```sh
echo "$var" | tr '[:lower:]' '[:upper:]'
```

### Loop over lines of a file
```sh
while IFS= read -r line; do
    echo "$line"
done < file
```

### Function-scoped variables
```sh
my_fn() {
    local x=1  # portable in practice on dash/ash/bash
    echo "$x"
}
```

## The strict header

```sh
#!/bin/sh
set -eu
```

There is no `pipefail` in POSIX. Some shells (dash) don't support it at all. Live with it, or check exit codes explicitly:
```sh
{ a | b; } && echo ok || echo "one of them failed"
```

## Testing

- `shellcheck --shell=sh` — catches bashisms.
- `dash script.sh` — the strictest common target.
- `docker run --rm -v "$PWD:/x" alpine sh /x/script.sh`.

## References

- POSIX shell command language: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
