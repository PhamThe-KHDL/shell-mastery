# Cheatsheet · sed

```sh
sed 's/old/new/' file          # first per line
sed 's/old/new/g' file         # all
sed 's/old/new/2' file         # 2nd match per line
sed 's/old/new/gi' file        # case-insensitive
sed 's|/a/b|/c/d|' file        # any delimiter

# In-place — portable
sed -i.bak 's/x/y/g' file      # works on GNU + BSD; leaves file.bak
sed -i 's/x/y/g' file          # GNU only
sed -i '' 's/x/y/g' file       # BSD (macOS) only

# Line addressing
sed -n '5p' file               # print only line 5
sed -n '5,10p' file            # print lines 5–10
sed -n '/pat/p' file           # lines matching /pat/
sed '1d' file                  # delete first line
sed '$d' file                  # delete last line
sed '/^#/d' file               # delete comment lines
sed '/pat/,/end/d' file        # delete range from /pat/ to /end/

# Multiple commands
sed -e 's/a/b/' -e 's/c/d/' file
sed 's/a/b/; s/c/d/' file

# Capture groups (extended regex)
sed -E 's/([0-9]+)-([0-9]+)/\2-\1/'

# Insert / append
sed '1i\
header line' file             # insert BEFORE line 1
sed '$a\
footer' file                   # append AFTER last line
```

**Trap**: BSD and GNU differ. `-i.bak` is the portable form.
