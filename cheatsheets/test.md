# Cheatsheet · test / `[ ]` / `[[ ]]`

Prefer `[[ ]]` in bash. Reserve `[ ]` for POSIX sh.

## Files

```sh
[[ -e file ]]         # exists (any type)
[[ -f file ]]         # regular file
[[ -d file ]]         # directory
[[ -L file ]]         # symlink
[[ -r file ]]         # readable
[[ -w file ]]         # writable
[[ -x file ]]         # executable
[[ -s file ]]         # exists and non-empty
[[ file1 -nt file2 ]] # file1 newer than file2
[[ file1 -ot file2 ]] # file1 older than file2
[[ file1 -ef file2 ]] # same inode (hardlinked)
```

## Strings

```sh
[[ -z "$s" ]]         # empty
[[ -n "$s" ]]         # non-empty
[[ "$a" == "$b" ]]    # equal (== also does glob in [[ ]])
[[ "$a" != "$b" ]]
[[ "$a" < "$b" ]]     # lexicographic (only in [[ ]])
[[ "$s" == foo* ]]    # glob match (only in [[ ]])
[[ "$s" =~ ^[0-9]+$ ]] # regex (only in [[ ]]) — DON'T quote right side
```

## Integers

```sh
[[ $a -eq $b ]]       # equal
[[ $a -ne $b ]]       # not equal
[[ $a -lt $b ]]       # less than
[[ $a -le $b ]]
[[ $a -gt $b ]]
[[ $a -ge $b ]]

# Arithmetic form (bash) — cleaner for math
(( a == b ))
(( a < b && b < 10 ))
```

## Boolean logic

```sh
[[ $a == 1 && $b == 2 ]]      # in [[ ]] only
[[ $a == 1 || $b == 2 ]]      # in [[ ]] only
[ "$a" = 1 ] && [ "$b" = 2 ]  # POSIX equivalent
! [[ -f file ]]               # negation
```

## Common bugs

- `[ $var = foo ]` fails if `$var` is empty. Always: `[ "$var" = foo ]` or use `[[ ]]`.
- `[[ ]]` uses `==` for glob, `=~` for regex. `[ ]` supports neither.
- Regex in `[[ =~ ]]`: **don't quote** the pattern — quoting makes it a literal string.
- `-a`/`-o` inside `[ ]` are deprecated; use two separate `[ ]` joined with `&&`/`||`.
