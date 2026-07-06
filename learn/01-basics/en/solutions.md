# Solutions 01 · Basics

## 1.
```sh
ls /nope /tmp > out.txt 2> err.txt || true
```

## 2.
```sh
find / -name '*.conf' 2>/dev/null | wc -l
```
Stderr is redirected to `/dev/null` **before** the pipe, so `wc -l` counts only stdout.

## 3.
```sh
touch -- '-rf ~'      # `--` lets touch accept the leading dash
rm ./'-rf ~'          # relative path — the `-` is no longer at the start of the argument
```

## 4.
```sh
shopt -s globstar
ls **/*.sh
```
Or use `find . -name '*.sh'` — more portable across shells.
