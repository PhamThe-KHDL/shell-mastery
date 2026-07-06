# Roadmap

Where `shell-mastery` is going. This is a living document — priorities move around, community feedback shifts things, and unplanned ideas land. Nothing here is a guarantee.

If you want something on this list, open an issue or PR. If you want something *not* on this list, open an issue anyway — that's how the list changes.

## Guiding principles

Every change is weighed against these:

1. **A learner-first repo, not a reference dump.** New content must serve someone working through the lessons. Cool trivia goes in a blog post, not here.
2. **Every runnable script has a test.** If it can't be tested, it goes in `snippets/`, not `lib/` or `projects/`.
3. **Bilingual (`en/` + `vi/`) prose in `learn/` — English only elsewhere.** Adding a third language would be a MAJOR undertaking; not currently planned.
4. **CI must stay green.** shellcheck-clean, all bats pass. No exceptions merged.
5. **Slow is fine.** This is a personal-learning repo. Depth beats velocity.

## Version targets

Rough anchor points. Dates are aspirational. **We're in pre-stable (`0.0.x`)** — every release is a patch bump, no interface guarantees. The jump to `0.1.0` marks the switch to real SemVer.

| Version | Theme | Target |
|---|---|---|
| **0.0.2** | Coverage — fill the gaps in v0.0.1's curriculum (networking, file-mgmt, processes, cron, JSON/YAML) | Q4 2026 |
| **0.0.3** | Real-world projects — 3 more end-to-end case studies (dotfiles installer, ssh-tunnel supervisor, repo audit) | Q1 2027 |
| **0.0.4** | Portability & POSIX story — dedicated lesson + tested `#!/bin/sh` companions | Q2 2027 |
| **0.0.5** | Interactive lesson runner — `./tools/study.sh` guides you through the curriculum | Q3 2027 |
| **0.0.6** | Interactive-shell config walkthroughs (`~/.bashrc`, `~/.zshrc` starting points) + `shells/nushell/` | Q4 2027 |
| **0.1.0** | First minor bump — stable curriculum surface, SemVer guarantees on `lib/`, published site (mdBook/Docusaurus) | Q1 2028 |
| **1.0.0** | Stable everything — breaking changes gated on MAJOR bumps from here on | 2028+ |

## By area

### `learn/` — new lessons

Planned additions, in rough priority order:

- [ ] **`07-networking`** — `curl`, `wget`, `ss`/`netstat`, `dig`, `nc`, SSH & SCP idioms, retry patterns for flaky endpoints.
- [ ] **`08-file-management`** — `find` deep dive, `tar`/`zip` archive strategies, safe `rm`, `rsync` for backups.
- [ ] **`09-processes`** — `ps`, `top`, `htop`, `pgrep`/`pkill`, `nohup`, `disown`, `nice`/`ionice`, `strace`/`lsof` basics.
- [ ] **`10-cron-and-scheduling`** — cron syntax, `at`, systemd timers, common cron gotchas (`$PATH`, `HOME`, TERM), locking with `flock`.
- [ ] **`11-json-and-yaml`** — `jq` fundamentals, `yq`, reading API responses in bash, when to stop and use Python.
- [ ] **`12-dates-and-times`** — GNU vs BSD `date`, epoch conversion, ISO 8601, timezone gotchas.
- [ ] **`13-networking-2`** — writing simple HTTP servers with `nc`, reverse tunnels, SSH multiplexing, `ProxyCommand`.
- [ ] **`14-testing-shell`** — bats-core deep dive, integration testing, mocking commands with `$PATH` shims, coverage with `bashcov`.

Each lesson still ships bilingual (`en/` + `vi/`) prose, English examples, exercises, and solutions. Adding one lesson is roughly 3 days of focused writing plus review.

### `topics/` — cross-cutting deep dives

- [ ] **`security/`** — shell scripts as an attack surface: quoting eval'd input, TOCTOU races, `mktemp` templates, safe `curl \| sh` patterns, secrets in env vars.
- [ ] **`concurrency/`** — mutex via `flock`, semaphores via named pipes, race conditions in cron, safe file locking on NFS.
- [ ] **`packaging/`** — distributing shell scripts as `.deb`, `.rpm`, `homebrew` formulas, `curl \| sh` installers.
- [ ] **`observability/`** — structured logging (JSON), metrics via textfile collector, distributed traces from a shell script.
- [ ] **`ci-cd-shell/`** — writing scripts for GitHub Actions / GitLab CI: matrix jobs, artifact handling, exit-code conventions, timeouts.

### `cheatsheets/` — additions

- [ ] `find.md` — every useful `find` flag and idiom.
- [ ] `curl.md` — the 20 flags you'll actually use.
- [ ] `jq.md` — after the JSON lesson lands.
- [ ] `ssh.md` — client config, ControlMaster, tunnels, keys.
- [ ] `tar.md` — archive/extract patterns, common footguns.
- [ ] `date.md` — GNU + BSD side-by-side.
- [ ] `strict-mode.md` — one page on `set -euo pipefail` + `IFS` + `trap ERR`.

### `shells/` — expansions

- [ ] Add benchmarks: `bash --posix` vs `dash` vs `busybox sh` startup time and script execution.
- [ ] Add `shells/nushell/` — how the modern data-oriented shell diverges from the Bourne family.
- [ ] Interactive shell config walkthroughs — a `~/.zshrc` and `~/.bashrc` known-good starting point in each.

### `projects/` — new case studies

Each should demonstrate skills from ≥3 lessons and have a full bats suite.

- [ ] **`dotfiles-installer/`** — idempotent, backs up existing configs, links vs copies, dry-run.
- [ ] **`ssh-tunnel-supervisor/`** — brings up a tunnel, restarts on death, exits cleanly on SIGTERM.
- [ ] **`repo-audit/`** — scans a directory of git repos, produces a CSV of size / activity / language / last commit.
- [ ] **`disk-usage-alert/`** — cron-safe threshold monitor, no re-alerting within N hours.
- [ ] **`log-rotator/`** — companion to `log-analyzer` — rotates and gzip-archives logs, keeps a retention window.
- [ ] **`prometheus-textfile-exporter/`** — writes atomic `.prom` files, exposes shell-collected metrics.

### `lib/` — additions

Additions must pass `shellcheck --severity=warning`, have a bats test file, and document their public interface.

- [ ] **`lib/lock.sh`** — `with_lock LOCKFILE CMD...` using `flock` on a fd for mutual exclusion.
- [ ] **`lib/require.sh`** — `require_cmd curl jq`, `require_env DB_URL API_KEY`, `require_bash 4.3`.
- [ ] **`lib/json.sh`** — thin wrappers over `jq` with sensible defaults, prep for the JSON lesson.
- [ ] **`lib/http.sh`** — `http_get URL`, `http_post URL DATA` with retry, JSON parsing, error mapping.
- [ ] **`lib/dates.sh`** — cross-platform `date` operations (yesterday, epoch, ISO).

### `snippets/` — additions

- [ ] `strict-header.sh` — copy-paste opening block (`#!/usr/bin/env bash`, strict mode, IFS, ERR trap).
- [ ] `tmpdir.sh` — inline (non-library) tempdir + trap pattern.
- [ ] `require-cmd.sh` — inline command-existence guard.
- [ ] `dispatch.sh` — subcommand pattern (`mycli status`, `mycli restart`).

### `tools/` — additions

- [ ] **`tools/format-all.sh`** — run `shfmt -w -i 4` across the tree.
- [ ] **`tools/check-links.sh`** — verify every markdown link inside the repo resolves to a real path (catches renamed lessons).
- [ ] **`tools/progress.sh`** — parse `learn/INDEX.md` and print your completed / remaining lessons; nice for `.bashrc` motd.
- [ ] **`tools/render-cheatsheets.sh`** — combine `cheatsheets/*.md` into one printable PDF via `pandoc`.
- [ ] **`tools/study.sh`** — interactive lesson runner: reads current status from INDEX, opens next lesson's `notes.md`, then runs tests as you complete each example.
- [ ] **`tools/new-project.sh`** — same shape as `new-lesson.sh` but scaffolds under `projects/`.
- [ ] **`tools/lint-md.sh`** — run `markdownlint` and `mdl` over documentation to catch broken tables and heading skips.

### CI / infra

- [ ] Cache shellcheck and bats between runs (currently reinstalls each time).
- [ ] Add a Windows job (Git Bash / WSL) to catch platform assumptions.
- [ ] Add an Alpine job — verify `#!/bin/sh` scripts under BusyBox `ash`.
- [ ] Add coverage report using `bashcov` or `kcov`.
- [ ] Add `actionlint` to `tools/lint-all.sh` (currently only in `build.yml`).
- [ ] Publish site — GitHub Pages rendering `learn/` as a book (mdBook or Docusaurus).
- [ ] Auto-publish CHANGELOG entries to a release feed.

### Meta

- [ ] `CONTRIBUTING.md` with detailed PR checklist.
- [ ] `CODE_OF_CONDUCT.md`.
- [ ] Issue templates for lesson requests, bug reports, project ideas.
- [ ] Add a `screenshots/` folder or GIFs demonstrating the projects.
- [ ] Translate `topics/` into Vietnamese — currently English only by design; user demand may change this.

## Stretch goals (interesting, not committed)

Things that would be great if someone champions them:

- **A companion Docker image** with bash, shellcheck, bats, shfmt preinstalled — one `docker run` and you're ready to work through the repo.
- **VS Code devcontainer** so learners with any OS can `code .` and get a consistent toolchain.
- **Slide deck** for teaching the curriculum to a small group.
- **Video walk-throughs** of `projects/backup-tool` and `projects/log-analyzer`, showing the reading approach.
- **Community answer sharing** — a place to see how other learners solved exercises.

## Non-goals (explicit)

Things we're **not** doing, so nobody wastes a PR on them:

- **A shell wrapper library that abstracts away bash.** The point is to learn bash, not hide it.
- **A rewrite in fish or zsh.** Scripts stay bash.
- **PowerShell coverage.** Different world.
- **A curriculum for real-time (WebSockets, event-loop) programming in bash.** Wrong tool.
- **Making examples run on Windows CMD.** Use WSL or Git Bash.
- **Chasing feature parity with online bash-teaching platforms.** They're products; this is a repo. Different constraints.

## How prioritization actually happens

Roughly, in order:

1. **Bug fixes to shipped content** — always first. If `learn/03` teaches a wrong syntax, that supersedes everything.
2. **Requested content with a specific use case** — someone said "I wish there was a lesson on X because I have Y problem" is 10× more actionable than "you should have X".
3. **My own learning gaps** — if I want to learn `flock`, that lesson gets written next. Selfish but effective.
4. **Everything else** — as time allows.

## How to help

- **Report typos and broken examples** — file an issue with the exact line.
- **Propose a lesson** — issue with a short outline; if approved, PR the scaffold via `./tools/new-lesson.sh`.
- **Contribute a project** — write it, test it, submit. Follow `projects/README.md` guidelines.
- **Improve a topic** — expand a section, add a worked example, fix a table.
- **Translate a lesson** — English → Vietnamese diffs are always welcome. Vietnamese → other languages is a bigger conversation; open an issue first.

See `CONTRIBUTING.md` (when it exists) for the mechanics.
