# Cheatsheet · Parameter expansion

```sh
${var}                  # explicit form, always safe
${var:-default}         # use default if unset OR empty
${var-default}          # use default if unset only
${var:=default}         # like :- but also assigns
${var:?message}         # error out with message if unset/empty
${var:+alt}             # alt if var IS set/non-empty, else empty

${#var}                 # string length
${var:offset}           # substring from offset
${var:offset:length}    # substring, offset & length

# Remove prefix / suffix (glob patterns, not regex)
${var#pattern}          # remove SHORTEST prefix match
${var##pattern}         # remove LONGEST prefix match
${var%pattern}          # remove SHORTEST suffix match
${var%%pattern}         # remove LONGEST suffix match

# Substitute
${var/pat/repl}         # replace FIRST match
${var//pat/repl}        # replace ALL matches
${var/#pat/repl}        # replace only if pat matches at START
${var/%pat/repl}        # replace only if pat matches at END

# Case (bash 4+)
${var,}                 # first char lowercase
${var,,}                # all lowercase
${var^}                 # first char uppercase
${var^^}                # all uppercase

# Indirection
${!name}                # value of the variable whose name is in $name

# Quote for reuse (bash 4.4+)
${var@Q}                # print quoted, safe to re-eval

# Common patterns
name=${path##*/}        # basename
dir=${path%/*}          # dirname
stem=${name%.*}         # strip extension
ext=${name##*.}         # extension only
```

Rule: if you can do it with parameter expansion, do it — no fork, no external tool.
