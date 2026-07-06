# Changelog

All notable changes to `shell-mastery` are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer](https://semver.org/).

**Current phase: pre-stable (`0.0.x`).** Every release increments the patch — MINOR bumps are reserved for the jump to `0.1.0` (see [`ROADMAP.md`](ROADMAP.md)) and later, and MAJOR bumps for `1.0.0` and beyond. Under `0.0.x` anything can move; no stability guarantees on `lib/` interfaces yet.

Once `0.1.0` ships:

- **MAJOR** — breaking changes to `lib/` public interfaces or repo layout that would invalidate reader bookmarks.
- **MINOR** — new lessons, projects, topics, or libraries.
- **PATCH** — content fixes, typos, small examples, doc improvements.

Unreleased work lives at the top under `## [Unreleased]` and moves down when a version is tagged.

---

## [Unreleased]

### Added
- `CONTRIBUTING.md` with folder-by-folder contribution rules, PR checklist, and explicit macOS Bash setup guidance.
- `tests/fixtures/log-analyzer.sample.log` so readers can run `projects/log-analyzer` without needing their own web-server log.
- `tests/lib_tempdir.bats` to pin down `lib/tempdir.sh` EXIT-trap behavior.

### Changed
- `README.md` now explains the real testing contract more precisely: `lib/` and `projects/` are bats-tested, while `learn/` examples and `snippets/` stay lightweight.
- `README.md` and `tools/README.md` now document the macOS Bash 4+/PATH setup explicitly.
- `projects/log-analyzer/README.md` and `projects/README.md` now point readers at checked-in fixture data for a faster first run.
- `tests/projects_log_analyzer.bats` now uses the checked-in fixture file instead of embedding sample input inline.

### Fixed
- `tools/check-deps.sh` now enforces the Bash 4+ requirement while treating `shfmt` as optional.
- `projects/backup-tool/backup.sh` now returns exit code `2` for missing option values and supports `--flag=value` syntax.
- `lib/tempdir.sh` now preserves an existing EXIT trap when sourced.
- `tests/lib_retry.bats` now uses ASCII test names so Bats does not skip tests on macOS/Bash combinations.

---

## [0.0.1] — 2026-07-06

Initial public version. The full 6-lesson curriculum, cross-cutting topics, cheatsheets, shell comparisons, two real projects, a sourceable library, and CI. Everything English-first with parallel Vietnamese notes in `learn/`.

### Added — Structure & tooling

- **Repository layout** with clear separation:
  - `learn/` — linear course with per-lesson `en/` + `vi/` prose and shared `examples/`.
  - `topics/` — cross-cutting deep dives (English only).
  - `cheatsheets/` — one-page references.
  - `shells/` — bash / zsh / fish / POSIX sh comparisons.
  - `snippets/` — copy-paste templates.
  - `lib/` — sourceable libraries with tests.
  - `projects/` — end-to-end case studies.
  - `tests/` — bats-core test suite mirroring source paths.
  - `tools/` — repo-management scripts.
- **`tools/new-lesson.sh`** — scaffolds a new lesson with `en/`, `vi/`, and `examples/` templates.
- **`tools/lint-all.sh`** — runs `shellcheck --severity=warning` on every `.sh` file. Compatible with macOS bash 3.2 (uses `find -exec`, not `mapfile`).
- **`tools/check-deps.sh`** — verifies bash 4+, shellcheck, bats, shfmt.
- **`.editorconfig`** — 4-space indent for `.sh`, 2-space for `.md`/`.yml`.
- **`.gitignore`** — `.DS_Store`, `*.log`, temp dirs, `scratch/`.
- **`.github/workflows/build.yml`** — CI runs `shellcheck` (lint job) + `bats` (test job) + `actionlint` on push, PR, weekly cron, and `workflow_dispatch`. Follows MarketDataX conventions (concurrency groups, timeouts, minimal permissions).
- **`.github/workflows/release.yml`** — creates a GitHub Release on `v*.*.*` tag push, with auto-generated notes.

### Added — Learning content (6 lessons, bilingual)

Every lesson: `en/notes.md`, `en/exercises.md`, `en/solutions.md`, mirror `vi/`, and 2–3 runnable examples in `examples/`.

- **`learn/01-basics/`** — navigation, three standard streams, redirect ordering, pipes, quoting, globbing. 2 examples.
- **`learn/02-text-processing/`** — grep flags, sed portability (`-i.bak` trick), awk pattern/action model, `cut`/`sort`/`uniq`/`tr`/`wc`, real 5-stage pipeline. 3 examples.
- **`learn/03-scripting-fundamentals/`** — variables, `[[ ]]` tests, `case`, `for`/`while`, functions with `local`, exit codes, `getopts`. 3 examples.
- **`learn/04-io-and-processes/`** — subshells and the pipe-into-while bug, `xargs -0` and `-P N`, background jobs + `wait`, `trap EXIT`/`INT TERM`, process substitution. 3 examples.
- **`learn/05-robust-scripts/`** — strict-mode header, `set -e` gotchas, `set -u` defaults, pipefail, ERR trap, input validation, atomic writes with `mv`. 3 examples.
- **`learn/06-advanced/`** — indexed and associative arrays, parameter expansion string ops, `local -n` nameref, regex with `=~`, `coproc`, when to leave shell. 3 examples.

### Added — Topics (cross-cutting deep dives)

- **`topics/quoting/`** — word splitting, IFS, `"$var"` vs `${arr[@]}`, 5 common pitfalls with fixes, when word splitting IS desired.
- **`topics/shellcheck/`** — install, editor integration for 5 IDEs, CI pattern, silencing rules, top 10 warnings, worked before/after example.
- **`topics/debugging/`** — `bash -n`, `bash -x`, `PS4`, `set -v`, `trap ERR`, `trap DEBUG`, `bashdb`, symptoms → causes table, 7-step debugging checklist.
- **`topics/performance/`** — fork cost mental model, order-of-magnitude table, 6 cheap wins, anti-patterns table, when to leave shell for awk / Python / Go.
- **`topics/portability/`** — 3-tier target decision (bash 4+, bash 3.2, POSIX sh), bash vs POSIX equivalents, tool differences (`sed -i`, `date`, `readlink -f`, `grep -P`, `stat`, `xargs -P`, `mktemp`), 3 testing strategies.

### Added — Cheatsheets

One-page references. No prose beyond one-line notes and a `**Pitfall**:` at the bottom.

- `cheatsheets/redirect.md`
- `cheatsheets/grep.md`
- `cheatsheets/sed.md`
- `cheatsheets/awk.md`
- `cheatsheets/arrays.md`
- `cheatsheets/parameter-expansion.md`
- `cheatsheets/test.md`

### Added — Shell comparisons

- **`shells/bash/`** — version table (3.2, 4.0, 4.3, 4.4, 5.x), startup files, `shopt` toggles, prompt basics.
- **`shells/zsh/`** — interactive superpowers vs bash, frameworks (oh-my-zsh, prezto, zim, starship), startup file order, scripting differences vs bash.
- **`shells/fish/`** — why interactive users love it, why scripts don't port, syntax difference table, config layout.
- **`shells/posix-sh/`** — what you don't have, POSIX idioms as bash-feature replacements, strict header, testing.

### Added — Snippets

- **`snippets/getopts.sh`** — short-flag CLI parser template.
- **`snippets/argparse.sh`** — long-flag `--name` and `--name=VAL` parser without getopts.

### Added — Libraries (sourceable, tested)

- **`lib/logger.sh`** — `log_debug`, `log_info`, `log_warn`, `log_error` with `LOG_LEVEL` env var and TTY-aware color output.
- **`lib/retry.sh`** — `retry MAX DELAY CMD...` with exponential backoff.
- **`lib/tempdir.sh`** — `make_tempdir` with an EXIT-trap cleanup that composes across multiple calls.
- **`lib/strings.sh`** — `trim`, `lower`, `upper`, `starts_with`, `ends_with`, `contains`, `join` (all fork-free using parameter expansion).

### Added — Projects

- **`projects/backup-tool/`** — timestamped `.tar.gz` backups with retention. Atomic `mv` from temp to final path; a crash never leaves partial archives. Supports short and long flags, `--dry-run`, and safe cleanup via `trap EXIT`.
- **`projects/log-analyzer/`** — reads Combined Log Format from stdin or a file; prints totals, top clients, status distribution, top paths, and 5xx errors. Uses per-section `awk` for constant-memory streaming.

### Added — Tests

- `tests/lib_logger.bats` — level filtering, stderr output.
- `tests/lib_retry.bats` — success first try, exhaustion, success on Nth attempt.
- `tests/lib_strings.bats` — trim, case, predicates, join.
- `tests/projects_backup_tool.bats` — missing flags exit 2, archive creation, contents verification, retention math, dry-run inertness, non-existent source.
- `tests/projects_log_analyzer.bats` — totals, unique counts, top client, 5xx surfacing, stdin fallback, `-n` validation.

### Added — Documentation

- **`README.md`** — who this is for, outcomes, layout table, getting started, study loop, conventions, contributing, references, license.
- **`learn/INDEX.md`** — prerequisites, lesson table with time estimates and dependencies, anatomy of a lesson, 6-step study loop, progress tracker, FAQ.
- **`resources.md`** — curated must-reads, reference docs, tools, books, blogs/talks, community, transition guide to Python/Go.
- Per-section READMEs (`projects/`, `lib/`, `snippets/`, `tools/`, `tests/`, `topics/`, `shells/`, `cheatsheets/`) — each explains layout, when to use it, how to contribute, and links to relevant lessons.

### Fixed (during initial build)

- `tools/lint-all.sh` originally used `mapfile`, which does not exist in macOS bash 3.2. Reworked to use `find -exec` for portability.
- `learn/01-basics/examples/02-quoting.sh` intentionally demonstrates a word-splitting bug; annotated with `# shellcheck disable=SC2068` and a comment.
- `learn/06-advanced/examples/03-nameref.sh` uses `local -n` where shellcheck can't detect the reference; annotated with `# shellcheck disable=SC2034` and a comment.
- `learn/04-io-and-processes/examples/03-subshell-bug.sh` renamed loop variable `n` → `_` since the value isn't used, silencing SC2034.

---

## Version conventions in future changes

**While in `0.0.x`** — bump the patch on every release, regardless of the change's size. Nothing here is API-stable yet. Batch related changes into one release rather than tagging trivially.

**From `0.1.0` onward** the SemVer rules take effect:

- **A change to `learn/` prose** is a MINOR bump if it adds a new lesson, PATCH otherwise.
- **A change to `lib/`** is MAJOR if it removes or renames a public function, MINOR if it adds one, PATCH for internal edits.
- **A change to `topics/`, `cheatsheets/`, `shells/`, `snippets/`** is PATCH regardless of size (they're reference material, not stable APIs).
- **A change to `projects/`** is MINOR if it adds a project, PATCH otherwise.
- **A change to `tools/` or CI** is MINOR if new behavior, PATCH if fixes.

Tag with `git tag v0.0.1`, `git tag v0.0.2`, etc. The `release.yml` workflow auto-generates release notes on push.

---

[Unreleased]: https://github.com/PhamThe-KHDL/shell-mastery/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/PhamThe-KHDL/shell-mastery/releases/tag/v0.0.1
