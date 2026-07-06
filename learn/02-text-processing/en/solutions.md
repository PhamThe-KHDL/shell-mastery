# Solutions 02 · Text processing

## 1.
```sh
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' file | sort -u
```

## 2.
```sh
awk '{print length($0)}' file | sort -n | uniq -c \
    | awk '{printf "%d: %d\n", $2, $1}'
```

## 3.
```sh
awk -F, -v OFS=, 'NR==1 {print; next} {print $3, $2, $1}' file.csv
```
This is fine for simple comma-delimited data. It is not a full CSV parser once fields may contain quoted commas or embedded newlines.

## 4.
```sh
grep -oE '^\[[A-Z]+\]' app.log | sort | uniq -c | sort -rn
```

## 5.
```sh
find dir -name '*.md' -print0 | xargs -0 sed -i.bak 's/oldname/newname/g'
find dir -name '*.md.bak' -delete
```
The `-i.bak` form is the portable trick — it works identically on GNU and BSD sed.
