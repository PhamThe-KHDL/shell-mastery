# 02 · Text processing — grep, sed, awk, cut, sort, uniq

## Goal

After this lesson you can:

- Search text with `grep` (basic vs extended regex, common flags).
- Transform text streams with `sed` (substitution, deletion, line ranges).
- Slice tabular data with `cut` and free-form data with `awk`.
- Sort and deduplicate with `sort` + `uniq`.
- Chain them into one pipeline instead of writing a script.

Rule of thumb: if you can solve it with one pipeline, don't write a script. If the pipeline hits three `awk`s, switch to a script.

## 1. `grep` — search

```sh
grep 'pattern' file          # matching lines
grep -i 'error' log          # case-insensitive
grep -v 'DEBUG' log          # invert
grep -n 'todo' *.md          # line numbers
grep -r 'foo' src/           # recurse
grep -c 'ERROR' log          # count only
grep -l 'password' -r .      # list files that contain the match
grep -E 'foo|bar' file       # extended regex (alternation)
grep -oE '[0-9]+'            # only the match, not the whole line
grep -A 2 -B 1 'panic'       # 2 lines after, 1 before each hit
```

Prefer `grep -E` — basic regex requires escaping `(`, `)`, `|`, `+`, `?`.

## 2. `sed` — stream editor

```sh
sed 's/old/new/' file        # first match per line
sed 's/old/new/g' file       # all matches
sed -i 's/foo/bar/g' file    # edit in place (GNU); macOS: sed -i '' 's/.../.../g'
sed -n '5,10p' file          # print lines 5–10
sed '/^#/d' file             # delete comment lines
sed 's|/old/path|/new/path|' # use | as delimiter for paths
sed -E 's/([0-9]+)/[\1]/g'   # capture group, extended regex
```

macOS `sed` (BSD) and GNU `sed` differ. Portable in-place: `sed -i.bak 's/.../.../g' file && rm file.bak`.

## 3. `awk` — column-oriented processing

Each line is split into fields on whitespace: `$1`, `$2`, ..., `$NF` (last), `$0` (whole line).

```sh
awk '{print $2}' file                  # 2nd field
awk -F, '{print $1}' file.csv          # field separator
awk 'NR==5' file                       # only line 5
awk 'length($0) > 80' file             # long lines
awk '/ERROR/ {print $1, $NF}' log      # pattern + action
awk '{sum+=$1} END {print sum}' nums   # running total
awk 'NR==FNR{a[$1]=1; next} $1 in a' A B  # join: keep B lines whose $1 is in A
```

`awk` is a small language. When you need 3 conditions and 2 arrays, move to a script — but until then, awk is fast and portable.

## 4. `cut`, `sort`, `uniq`, `tr`, `wc`

```sh
cut -d, -f1,3 file.csv       # fields 1 and 3, delimiter comma
cut -c1-10 file              # characters 1–10

sort file                    # lexicographic
sort -n file                 # numeric
sort -k2,2 file              # by field 2 only
sort -u file                 # sort + dedup
sort -t, -k3,3n -k1,1 f.csv  # multi-key

uniq file                    # remove ADJACENT dups (sort first!)
uniq -c file                 # prefix with count
sort file | uniq -c | sort -rn   # frequency table

tr 'a-z' 'A-Z' < file        # uppercase
tr -d '\r' < win.txt         # strip CRs
tr -s ' '                    # squeeze runs of spaces

wc -l file                   # count lines
wc -c file                   # bytes
```

## 5. A real pipeline

"Top 10 IPs by request count in an access log":

```sh
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

Five stages, no temp files, streams line-by-line — memory doesn't matter.

## Further reading

- [cheatsheets/grep.md](../../../cheatsheets/grep.md)
- [cheatsheets/sed.md](../../../cheatsheets/sed.md)
- [cheatsheets/awk.md](../../../cheatsheets/awk.md)
- `man grep`, `man sed`, `man awk`.
