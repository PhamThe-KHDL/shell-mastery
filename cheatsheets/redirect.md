# Cheatsheet · Redirect

```sh
cmd > file           # stdout → file (overwrite)
cmd >> file          # stdout → file (append)
cmd 2> file          # stderr → file
cmd &> file          # stdout + stderr → file (bash)
cmd > file 2>&1      # stdout + stderr → file (POSIX)
cmd &>> file         # append both (bash)
cmd < file           # stdin from file
cmd <<< "string"     # here-string
cmd <<EOF            # here-doc
multi
line
EOF
cmd | tee file       # stdout → file AND terminal
cmd 2>&1 | grep err  # pipe stderr too
cmd > /dev/null      # discard stdout
cmd 2>/dev/null      # discard stderr
exec > log.txt       # from this line on, all script stdout goes to log.txt
```

**Pitfall**: `cmd 2>&1 > file` does NOT put stderr in the file. Correct: `cmd > file 2>&1`.
