# Exercises 03 · Scripting fundamentals

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. FizzBuzz
Print 1..30, replace multiples of 3 with `Fizz`, of 5 with `Buzz`, of both with `FizzBuzz`.

## 2. Safe default
Write a function `greet` that takes 1 argument (a name). If called with no argument, use `world`. Never let a missing argument break the script.

## 3. Argument parser
Write a script that accepts `-n NAME` (required) and `-c COUNT` (default 1) and prints `hello, NAME` repeated `COUNT` times. Reject unknown flags with a proper usage message.

## 4. Retry with backoff
Write a function `retry MAX CMD...` that runs `CMD` up to `MAX` times, sleeping 1, 2, 4, ... seconds between attempts. Return the last exit code.

## 5. Chain vs conditional
Explain in one sentence why `cmd1 && cmd2 || cmd3` is not the same as if/then/else.
