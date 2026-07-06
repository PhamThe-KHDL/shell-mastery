# Exercises 14-testing-shell

Try each on your own, then check [`solutions.md`](solutions.md).

## 1. Write one library test
Source a function file with `load` and assert one happy-path result.

## 2. Test a script failure
Call a script with missing required flags and assert that it exits with code `2`.

## 3. Use a temp directory
Write a test that creates files in `setup()`, runs a script, then cleans everything in `teardown()`.
