# Solutions 14-testing-shell

## 1. Write one library test

```bash
#!/usr/bin/env bats

load '../lib/strings.sh'

@test "trim removes outer whitespace" {
    result=$(trim "  hello  ")
    [ "$result" = "hello" ]
}
```

Library tests usually `load` the file and call the function directly. That keeps the test tight and makes failures easier to understand.

## 2. Test a script failure

```bash
#!/usr/bin/env bats

SCRIPT="./projects/backup-tool/backup.sh"

@test "missing --source exits 2" {
    run "$SCRIPT" --dest /tmp/out
    [ "$status" -eq 2 ]
    [[ "$output" == *"Usage:"* ]]
}
```

`run` is the important helper here. Without it, the non-zero exit would abort the test before you could assert on `$status` and `$output`.

## 3. Use a temp directory

```bash
#!/usr/bin/env bats

setup() {
    tmp=$(mktemp -d)
    printf 'hello\n' >"$tmp/input.txt"
}

teardown() {
    rm -rf "$tmp"
}

@test "script writes output file" {
    run cp "$tmp/input.txt" "$tmp/output.txt"
    [ "$status" -eq 0 ]
    [ -f "$tmp/output.txt" ]
}
```

Every test should get its own clean filesystem state. `setup()` creates it, `teardown()` removes it, and nothing leaks into the next test.
