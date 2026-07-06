# Cheatsheet · grep

```sh
grep 'pat' file          # matching lines
grep -i 'err' file       # case-insensitive
grep -v 'debug' file     # invert
grep -n 'todo' file      # show line numbers
grep -c 'err' file       # count only
grep -l 'secret' -r .    # list files that contain a match
grep -L 'foo' *.md       # list files that do NOT contain a match
grep -r 'foo' src/       # recurse
grep -R 'foo' src/       # recurse and follow symlinks
grep -E 'a|b' file       # extended regex (or)
grep -F 'a.b' file       # fixed string (no regex)
grep -w 'error' file     # whole word only
grep -x '^done$' file    # whole line only
grep -o '[0-9]+' file    # print only matches, not lines
grep -A 3 -B 1 'panic'   # 3 lines after, 1 before
grep -C 2 'err' file     # 2 lines context (both sides)
grep --color=auto        # highlight matches
grep -q 'foo' && ...     # quiet — check exit code only

# Common patterns
grep -rn --include='*.py' 'TODO' .   # only search .py files
grep -rn --exclude-dir=node_modules 'foo' .
```

Prefer `grep -E` for readable regex — no backslash-escape for `(`, `)`, `|`, `+`, `?`.
