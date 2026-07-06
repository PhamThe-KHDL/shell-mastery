# 14-testing-shell

## Goal
- Turn shell testing from “I know Bats exists” into a repeatable workflow.
- Learn how to test functions, scripts, failures, and filesystem effects without guessing.

## 1. What Bats actually is

Bats is just bash plus a test runner.

Each `@test` block is a bash function:

```bash
@test "trim: removes outer whitespace" {
    result=$(trim "  hello  ")
    [ "$result" = "hello" ]
}
```

If a command exits non-zero, the test fails unless you wrapped it with `run`.

## 2. `run` is the key helper

Use `run` when a command might fail and you want to inspect the failure:

```bash
run "$SCRIPT" --bad-flag
[ "$status" -eq 2 ]
[[ "$output" == *"Usage:"* ]]
```

Without `run`, a non-zero exit would abort the test immediately.

## 3. Libraries vs scripts

Test them differently:

- `lib/*.sh` → `load` the file and call functions directly
- `projects/*.sh` → run the script as a subprocess

This mirrors how callers actually use the code.

## 4. Filesystem tests need tempdirs

The clean default is:

```bash
setup() {
    tmp=$(mktemp -d)
}

teardown() {
    rm -rf "$tmp"
}
```

Do not let tests share filesystem state unless you have a very specific reason.

## 5. What to cover

A minimal useful shell test suite covers:

1. one happy path
2. one invalid-input path
3. one edge case

For scripts, that often means:

- required flags missing
- one successful run
- a failure such as unreadable input or bad config

## 6. When to stop using shell tests

Shell + Bats is excellent for command-line behavior, exit codes, and light filesystem effects.
It gets painful when you need:

- heavy fixture generation
- complex JSON assertions
- cross-process orchestration
- rich mocking

At that point, Python `pytest` plus `subprocess` is usually the better tool.

## Further reading
- `tests/README.md` — the applied in-repo companion to this lesson, with worked examples from the actual test suite.
- `tests/` — especially `tests/projects_backup_tool.bats` and `tests/lib_strings.bats` — as worked examples you can read right now.
