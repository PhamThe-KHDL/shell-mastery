# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`shell-mastery` is a **learning curriculum**, not an application. There is no build step and no runtime service — the "product" is documentation plus small, correct, tested shell scripts. Optimize every change for a reader working sequentially through the lessons, not for feature velocity.

## Commands

```sh
./tools/check-deps.sh                 # verify bash 4+, shellcheck, bats (shfmt optional)
./tools/lint-all.sh                   # shellcheck --severity=warning on every .sh file
bats tests/                           # run the whole test suite
bats tests/lib_retry.bats             # run one test file
bats tests/lib_retry.bats -f "exponential"   # run tests matching a name pattern
./tools/new-lesson.sh NN-slug         # scaffold learn/NN-slug/{en,vi,examples}
```

`./tools/lint-all.sh` and `bats tests/` are the two hard gates — CI runs exactly these. Run both before proposing any change is done.

**Verify tests against a clean checkout, not just the working tree.** Some fixtures live under paths matched by `.gitignore` (`*.log`) and are only tracked via a negation rule (`!tests/fixtures/*.log`). A test can pass locally off an untracked file yet fail in CI. To reproduce CI's view: `git archive HEAD | tar -x -C "$(mktemp -d)"` then run `bats tests/` there.

## Bilingual convention (easy to get wrong)

Prose is bilingual in exactly two places, both via `en/` + `vi/` subfolders:
- `learn/<lesson>/{en,vi}/{notes,exercises,solutions}.md`
- `topics/<slug>/{en,vi}/README.md`

Everything else — code, **all code comments**, `cheatsheets/`, `shells/`, and every other section `README.md` — stays **English only**. When you touch one language of a lesson or topic, mirror the change in the other in the same change; the two are kept structurally parallel (heading-for-heading). Vietnamese should read naturally to a Vietnamese learner, not be a literal translation of the English.

Examples under `learn/*/examples/` are shared across both languages, so their comments are English.

## Testing contract (what is and isn't tested)

Only `lib/` and `projects/` promise behavior and therefore have bats tests. `learn/` examples and `snippets/` are intentionally untested teaching material / copy-paste templates. Test files mirror the source path with slashes turned into underscores:

- `lib/retry.sh` → `tests/lib_retry.bats`
- `projects/backup-tool/backup.sh` → `tests/projects_backup_tool.bats`

Test libraries by `load`-ing them and calling functions directly; test `projects/` scripts by running them as a subprocess so argument parsing and exit codes are covered too.

## Shell conventions enforced repo-wide

- `#!/usr/bin/env bash` + `set -euo pipefail`; `lib/*.sh` are sourced, not executed, so they have no exec bit.
- Target **bash 4+**. macOS ships bash 3.2 — avoid `mapfile`, associative arrays, `${var,,}`, `local -n` in anything meant to run on stock macOS, and note the requirement. `tools/lint-all.sh` itself stays 3.2-compatible (`find -exec`, no `mapfile`).
- **shellcheck must pass at `--severity=warning`.** A `# shellcheck disable=SCxxxx` requires an inline comment explaining why.
- Prefer parameter expansion over forking (`${path##*/}` not `basename`); this is a recurring point the lessons and `topics/performance` teach, so example code should model it.

## Directory taxonomy (each has one purpose)

`learn/` linear course · `topics/` cross-cutting deep dives (bilingual) · `cheatsheets/` one-page references · `shells/` bash/zsh/fish/posix-sh comparisons · `snippets/` copy-paste templates · `lib/` sourceable tested libraries · `projects/` end-to-end tested case studies · `tools/` repo-maintenance scripts · `tests/` bats suite. `learn/INDEX.md` is the study entry point; keep its lesson table in sync when adding a lesson.

## Versioning & commits

Pre-stable (`0.0.x`): every release is a patch bump, no `lib/` interface guarantees until `0.1.0` (see `CHANGELOG.md` / `ROADMAP.md`). User-visible changes get a line under `CHANGELOG.md` → `## [Unreleased]`. Commit messages reference the area, e.g. `feat(learn/02): add sed portability example`, `fix(projects/backup-tool): atomic mv on same fs`.
