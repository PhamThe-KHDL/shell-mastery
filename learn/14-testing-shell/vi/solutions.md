# Lời giải 14-testing-shell

## 1. Viết một library test

```bash
#!/usr/bin/env bats

load '../lib/strings.sh'

@test "trim removes outer whitespace" {
    result=$(trim "  hello  ")
    [ "$result" = "hello" ]
}
```

Với library test, bạn thường `load` file rồi gọi function trực tiếp. Cách này gọn và giúp nhìn lỗi dễ hơn.

## 2. Test một script failure

```bash
#!/usr/bin/env bats

SCRIPT="./projects/backup-tool/backup.sh"

@test "missing --source exits 2" {
    run "$SCRIPT" --dest /tmp/out
    [ "$status" -eq 2 ]
    [[ "$output" == *"--source is required"* ]]
}
```

`run` là helper quan trọng ở đây. Nếu không có nó, exit non-zero sẽ làm test abort trước khi bạn kịp assert `$status` và `$output`.

## 3. Dùng temp directory

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

Mỗi test nên có filesystem state sạch của riêng nó. `setup()` tạo ra nó, `teardown()` xóa đi, và không có gì rò sang test tiếp theo.
