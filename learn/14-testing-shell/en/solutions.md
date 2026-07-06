# Solutions 14-testing-shell

## 1.
Use `load '../lib/foo.sh'` and plain shell assertions for direct function tests.

## 2.
`run "$SCRIPT"` then check `$status` instead of letting the test abort early.

## 3.
`mktemp -d` plus `teardown()` is the clean default for filesystem tests.
