# Exercises 06 · Advanced

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Unique-preserving dedup
Given a stream of lines, print each line only the first time it appears (preserve original order). Do it with an associative array — no `sort`.

## 2. Parse a path
Given `$path`, extract dir, filename (with extension), stem (no extension), and extension using only parameter expansion.

## 3. Regex capture
Parse a line like `[2024-01-15T10:30:45Z] user=alice action=login` into three variables `ts`, `user`, `action` using `=~`.

## 4. Function returning an array
Write `top_n SRC_ARRAY OUT_ARRAY N` that populates `OUT_ARRAY` with the largest `N` elements of the numeric input array `SRC_ARRAY`. Use nameref.

## 5. When NOT to use bash
Give one example where reaching for Python is the right call — and why the shell version would be worse.
