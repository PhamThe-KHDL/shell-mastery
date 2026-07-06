# Lời giải 01 · Basics

## 1.
```sh
ls /nope /tmp > out.txt 2> err.txt || true
```

## 2.
```sh
find / -name '*.conf' 2>/dev/null | wc -l
```
Stderr đã bị vứt vào `/dev/null` **trước khi** đi qua pipe, nên `wc -l` chỉ đếm stdout.

## 3.
```sh
touch -- '-rf ~'      # `--` cho phép touch nhận argument bắt đầu bằng dấu -
rm ./'-rf ~'          # đường dẫn tương đối → dấu `-` không còn ở đầu argument
```

## 4.
```sh
shopt -s globstar
ls **/*.sh
```
Hoặc dùng `find . -name '*.sh'` — portable hơn giữa các shell.
