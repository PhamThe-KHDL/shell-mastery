# Exercises 01 · Basics

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Redirect
Write a single command that runs `ls /nope /tmp` so stdout goes to `out.txt`, stderr goes to `err.txt`, and the shell reports exit code 0.

## 2. Count matching lines
Given `find / -name '*.conf' 2>/dev/null`, count the number of **matching** lines (not error lines). Don't use a temp file.

## 3. Quoting
Create a file literally named `-rf ~` (yes, really). Then delete it **safely without** using `rm --`. Hint: paths.

## 4. Globbing
List every `.sh` file in this repo, including nested ones. Bash does not recurse by default — what do you need to enable?
