# Contributing

Thanks for helping improve `shell-mastery`.

This repo is a learning curriculum first and a codebase second, so contributions are judged by one question above all: **will this make the repo clearer, safer, or more useful for the next learner?**

## Before you start

Read these first:

- [`README.md`](README.md) — the repo's promise and structure.
- [`learn/INDEX.md`](learn/INDEX.md) — how the curriculum is meant to be used.
- [`ROADMAP.md`](ROADMAP.md) — what's planned, what is explicitly not planned.

Then make sure your local environment is ready:

```sh
./tools/check-deps.sh
```

On macOS, `brew install bash` is not enough by itself if `which bash` still prints `/bin/bash`.
You need your shell to find Homebrew's Bash first:

```sh
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zprofile
exec zsh
which bash
bash --version
```

Expected result:

- `which bash` → `/opt/homebrew/bin/bash`
- `bash --version` → `4.x` or `5.x`

## What kinds of changes are welcome

Good contributions:

- Fix wrong shell syntax, broken examples, bad explanations, or misleading docs.
- Add tests that pin down behavior more clearly.
- Improve onboarding for beginners.
- Add lessons, projects, topics, or cheatsheets that match the repo's scope.
- Tighten consistency between docs, tests, CI, and implementation.

Please avoid:

- Adding advanced material with no connection to the learning path.
- Introducing extra tooling just because it is trendy.
- Turning `snippets/` into a general-purpose dotfiles dump.
- Adding a large new area without first checking that it fits [`ROADMAP.md`](ROADMAP.md).

## Content rules by area

### `learn/`

Use this for curriculum content only.

Each lesson must include:

- `en/notes.md`
- `en/exercises.md`
- `en/solutions.md`
- `vi/notes.md`
- `vi/exercises.md`
- `vi/solutions.md`
- `examples/` with runnable `.sh` files

If you add a lesson:

1. Scaffold it with `./tools/new-lesson.sh NN-topic`.
2. Fill both language folders.
3. Add a row to [`learn/INDEX.md`](learn/INDEX.md).
4. Make sure examples stay in English comments only.

### `topics/`

Use this for cross-cutting deep dives, not lesson content and not quick-reference material.

A topic belongs here if it:

- touches multiple lessons
- needs more explanation than a cheatsheet
- helps a learner solve a real recurring shell problem

### `cheatsheets/`

Use this for short, dense reference pages.

No long prose. Prefer syntax, idioms, and one clear pitfall note.

### `snippets/`

Snippets are copy-paste templates, not stable APIs.

They do **not** need Bats tests, but they should:

- be shellcheck-clean
- be obviously adaptable
- avoid hidden assumptions

If a snippet stabilizes into a reusable interface, promote it to `lib/`.

### `lib/`

Libraries are sourceable, documented, and tested.

A new library must include:

- the `.sh` file in `lib/`
- a matching `tests/lib_<name>.bats`
- a short documented public interface in [`lib/README.md`](lib/README.md)

Assume `lib/` APIs will eventually fall under SemVer guarantees.

### `projects/`

Projects are end-to-end scripts that demonstrate multiple lessons working together.

A new project should have:

- its own folder under `projects/<name>/`
- a self-contained `README.md`
- at least one runnable script
- a matching `tests/projects_<name>.bats`
- realistic sample input or fixtures where useful

### `tools/`

Tools are for maintaining this repo itself.

If a tool contains real logic, add tests for it. `new-lesson.sh` is a good candidate for future coverage.

## Style rules

For shell code:

- Use `#!/usr/bin/env bash`.
- Use `set -euo pipefail`.
- Add `IFS=$'\n\t'` in robust scripts when word-splitting safety matters.
- Pass `shellcheck --severity=warning`.
- If you disable a ShellCheck rule, add a short reason on the same line.

For prose:

- Prefer concrete examples over abstract explanation.
- Write for a learner who is smart but not yet fluent.
- Avoid unexplained jargon.
- Keep code and code comments in English.
- Keep lesson prose mirrored in both `en/` and `vi/`.

## Pull request checklist

Before opening a PR, run:

```sh
./tools/lint-all.sh
bats tests/
```

If you changed docs in a way that updates repo behavior or promises, also update:

- [`README.md`](README.md)
- [`CHANGELOG.md`](CHANGELOG.md)
- any section README that now describes outdated behavior

Quick self-check:

- Did I make the repo clearer for a first-time learner?
- Did I keep docs, code, and tests in sync?
- Did I avoid adding a new concept without showing how it fits the learning path?

## Small vs large changes

Small changes can go straight to PR:

- typos
- broken links
- sample-output fixes
- tests for existing behavior

For larger changes, open an issue first:

- a new lesson
- a new library
- a new project
- a new topic area
- a tooling or CI workflow change with repo-wide impact

## Release notes

If your change is user-visible, add a short note under [`CHANGELOG.md`](CHANGELOG.md) → `## [Unreleased]`.
