# Exercises 04 · I/O and processes

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Explain the bug
```sh
lines=0
find . -type f | while read -r _; do lines=$((lines+1)); done
echo "$lines"
```
Why does this print 0? Give two ways to fix it.

## 2. Safe temp dir
Write a script that downloads (or `curl`s) 3 URLs into a temp directory and gzip-tars them. The temp dir must be deleted no matter how the script exits.

## 3. Parallelize
You have 100 URLs in a file, one per line. Fetch all of them with `curl -sI` and keep only the status line, using 10 parallel workers. Output must be one status line per input URL, in any order.

## 4. Graceful cancel
Write a `while true; sleep 1` loop that, on Ctrl-C, prints `"stopping"` and exits 0.

## 5. Find + xargs safety
`find . -name '*.log' | xargs rm` fails on a file called `my log.log`. Fix it two different ways.
