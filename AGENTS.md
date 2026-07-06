# Repository Guidelines

## Project Structure & Module Organization

`learn/` is the curriculum: each lesson has `en/`, `vi/`, and shared `examples/`. `topics/` holds cross-cutting deep dives, `cheatsheets/` is quick lookup, and `shells/` compares bash, zsh, fish, and POSIX sh. Reusable code lives in `lib/`, end-to-end case studies live in `projects/`, and mirrored Bats tests live in `tests/`. Repo-maintenance scripts are under `tools/`.

## Build, Test, and Development Commands

- `./tools/check-deps.sh` checks local prerequisites such as Bash 4+, `shellcheck`, and `bats`.
- `./tools/lint-all.sh` runs ShellCheck across every `.sh` file.
- `bats tests/` runs the full test suite.
- `bats tests/lib_retry.bats` runs one test file.
- `./tools/new-lesson.sh 15-your-topic` scaffolds a new lesson folder.

Run lint and tests before opening a PR.

## Coding Style & Naming Conventions

Shell scripts use `#!/usr/bin/env bash` and generally start with `set -euo pipefail`. Prefer ASCII, 4-space indentation in `.sh`, and kebab-case lesson/project directory names like `10-cron-and-scheduling`. Keep code and code comments in English. Use `shellcheck --severity=warning`; if you disable a rule, add a brief reason inline.

## Testing Guidelines

Tests use `bats-core`. Mirror source paths in test filenames: `lib/retry.sh` -> `tests/lib_retry.bats`, `projects/backup-tool/backup.sh` -> `tests/projects_backup_tool.bats`. Cover at least one happy path and one failure mode. Use `mktemp -d` in `setup()` for filesystem tests and clean up in `teardown()`.

## Commit & Pull Request Guidelines

Recent history uses Conventional Commit-style subjects such as `feat: ...`, `fix(tests): ...`, and scoped docs/code updates. Follow that pattern and keep subjects specific. PRs should explain learner-facing impact, mention changed paths, and update `CHANGELOG.md` under `## [Unreleased]` when behavior or repo promises change.

## Content Rules

Keep `learn/` and `topics/` bilingual: if you change `en/`, update `vi/` in the same PR. `snippets/` are templates, not stable APIs. If an interface becomes reusable, move it into `lib/` and add tests.
