# tests

Automated tests for everything under `lib/` and `projects/`, written in [bats-core](https://github.com/bats-core/bats-core).

The layout **mirrors** the source path so any file is one grep away from its tests:

| Source | Test |
|---|---|
| `lib/logger.sh`                    | `tests/lib_logger.bats` |
| `lib/retry.sh`                     | `tests/lib_retry.bats` |
| `lib/strings.sh`                   | `tests/lib_strings.bats` |
| `lib/tempdir.sh`                   | `tests/lib_tempdir.bats` |
| `projects/backup-tool/backup.sh`   | `tests/projects_backup_tool.bats` |
| `projects/log-analyzer/analyze.sh` | `tests/projects_log_analyzer.bats` |

Slashes in the source path become underscores in the test filename.

`learn/` examples and `snippets/` are intentionally not mirrored here: lesson examples optimize for teaching one idea at a time, and snippets are copy-paste templates rather than stable interfaces.

This split is deliberate:

- `learn/` teaches concepts
- `lib/` and `projects/` promise behavior
- `tests/` pins that behavior down so refactors stay honest

## Prerequisites

```sh
brew install bats-core          # macOS
sudo apt install bats           # Debian/Ubuntu
```

Verify:
```sh
bats --version
```

## Running tests

```sh
# Run everything
bats tests/

# Run one file
bats tests/lib_retry.bats

# Run one test (by name pattern)
bats tests/lib_retry.bats -f "succeeds on second attempt"

# TAP output (machine-readable)
bats -t tests/
```

Exit code is 0 if all tests pass, non-zero otherwise. The build workflow runs the full suite on pull requests to `main`, pushes to `main`, and scheduled/manual runs.

## Reading a bats file

Bats is bash with a thin test runner. Each `@test` block is an isolated bash function; the runner captures its exit code and any output.

```bash
@test "trim: strips leading and trailing whitespace" {
    result=$(trim "   hello world   ")
    [ "$result" = "hello world" ]
}
```

Common idioms:

- `run cmd args...` — execute a command and capture its output into `$output` and its exit code into `$status`. Use when the command might fail; `run` doesn't propagate the failure to the test.
- `[ "$status" -eq 0 ]` — plain `[ ]` assertions. If any assertion fails, the test fails.
- `[[ "$output" == *"substring"* ]]` — glob check on captured output.
- `load '../lib/foo.sh'` — source a library from the test file. `load` is bats-provided and resolves relative to the test file's directory.
- `setup()` / `teardown()` — run before/after each test in the file. Use for tempdirs, fixtures.

Full syntax: https://bats-core.readthedocs.io

## Writing a new test file

```sh
touch tests/lib_mynew.bats
```

Skeleton:

```bash
#!/usr/bin/env bats

setup() {
    load '../lib/mynew.sh'
}

@test "does the happy thing" {
    result=$(my_function ok)
    [ "$result" = "ok" ]
}

@test "fails loudly on bad input" {
    run my_function
    [ "$status" -ne 0 ]
}
```

Guidelines:

- Cover the happy path AND at least one failure mode.
- Use `mktemp -d` in `setup()` for anything that touches the filesystem, and clean it up in `teardown()`.
- Keep tests independent — no shared state between `@test` blocks.
- Name tests as a description of the behavior, not the function (`"missing required flags: exit 2"` beats `"test_flags"`).

Good default shape for new contributors:

- 1 happy-path test
- 1 misuse or missing-input test
- 1 edge case that would have broken in the past

## Testing scripts vs libraries

For libraries under `lib/`, `load` the file and call the functions directly.

For scripts under `projects/`, call the script as a subprocess so you also test argument parsing and exit codes:

```bash
BACKUP=projects/backup-tool/backup.sh

@test "missing required flags: exit 2" {
    run "$BACKUP"
    [ "$status" -eq 2 ]
}
```

The `projects_backup_tool.bats` and `projects_log_analyzer.bats` files are worked examples of this pattern.

When you are unsure how much to test, bias toward public behavior:

- exit codes
- stderr/user-facing messages
- created or deleted files
- output format that another script may consume

## Things bats can't easily do

- **Interactive prompts** — bats doesn't provide a stdin driver. Refactor to accept flags instead of prompts.
- **Timing-sensitive tests** — bats runs each test to completion. If your code sleeps 5 seconds, the test takes 5 seconds.
- **Ctrl-C simulation** — for signal-handling tests, background the process and `kill -INT $pid`.

When bats hits its limits, Python's `subprocess` + `pytest` is the natural upgrade.
