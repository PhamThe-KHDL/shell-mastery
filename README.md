# shell-mastery

A learning repository for Unix shell — from your first `ls` to production-grade bash scripts. Structured as a study path with parallel English/Vietnamese notes, runnable examples, exercises with solutions, real projects, and a CI pipeline that lints and tests every script.

## Who this is for

- **Newcomers** who want a linear path from "what's a terminal?" to writing scripts they trust.
- **Working developers** who use shell every day but never sat down to learn it properly — the ones who Google the same `find` incantation every month.
- **Anyone maintaining bash** on a real codebase who needs to write scripts that survive contact with production (weird filenames, missing env vars, partial failures, someone hitting Ctrl-C).

If you already know shell inside-out, this repo is not for you — head to the `references` at the bottom.

## What you get by the end

You will be able to:

1. **Navigate and combine tools fluently** — pipe `grep | awk | sort` without thinking, know when to reach for `xargs` vs a `for` loop.
2. **Write scripts that fail loudly, not silently** — strict mode, input validation, atomic writes, cleanup on exit.
3. **Debug shell scripts systematically** — `set -x`, `PS4`, `trap ERR`, shellcheck warnings.
4. **Know the boundaries** — recognize when a task has outgrown shell and reach for `awk`, Python, or Go.

## Repository layout

| Path | Purpose | Read when |
|---|---|---|
| [`learn/`](learn/) | Lessons in study order. Each lesson has `en/` + `vi/` prose and shared `examples/`. | You want a structured path from 0 to advanced. Start at [`learn/INDEX.md`](learn/INDEX.md). |
| [`topics/`](topics/) | Cross-cutting reference: quoting, shellcheck, debugging, performance, portability. | You hit a specific problem and need the deep dive. |
| [`cheatsheets/`](cheatsheets/) | One page per topic. No prose — just commands. | You know what to do; you forgot the exact syntax. |
| [`shells/`](shells/) | Comparison of bash / zsh / fish / POSIX sh. | You're choosing a shell or debugging a "works on my machine". |
| [`snippets/`](snippets/) | Copy-paste templates (arg parsers, etc.). | You start a new script and want a boilerplate. |
| [`lib/`](lib/) | Sourceable helper libraries with tests. | You want a `retry`, `logger`, `tempdir`, or string helper without reinventing it. |
| [`projects/`](projects/) | Full end-to-end scripts — read them like case studies. | You've done the lessons and want to see what "finished" looks like. |
| [`tests/`](tests/) | bats-core tests mirroring `lib/` and `projects/`. | You want to see how to test bash. Also, they run in CI. |
| [`tools/`](tools/) | Scripts that manage this repo (new lesson, lint, deps check). | You contribute or extend the repo. |

## Getting started

### 1. Prerequisites

You need bash 4.0+. Check with `bash --version`.

- **Linux**: you already have it.
- **macOS**: default `/bin/bash` is **3.2** (from 2007). Install a modern one: `brew install bash`. Scripts here use `#!/usr/bin/env bash`, which picks up the new one from `$PATH`.

Optional tooling (recommended):

```sh
brew install shellcheck bats-core shfmt
# or on Debian/Ubuntu:
sudo apt install shellcheck bats
```

Verify:

```sh
./tools/check-deps.sh
```

### 2. Read the study guide

Open [`learn/INDEX.md`](learn/INDEX.md) — it lays out the order and a study loop.

### 3. Do your first lesson

```sh
# Read the notes
$EDITOR learn/01-basics/en/notes.md    # or vi/notes.md

# Run and modify the examples
bash learn/01-basics/examples/01-redirect.sh
bash learn/01-basics/examples/02-quoting.sh

# Attempt the exercises
$EDITOR learn/01-basics/en/exercises.md

# Compare to solutions after honest effort
$EDITOR learn/01-basics/en/solutions.md
```

### 4. Add a lesson (later)

```sh
./tools/new-lesson.sh 07-networking
# scaffolds learn/07-networking/{en,vi,examples}
# don't forget to add a row to learn/INDEX.md
```

### 5. Lint and test

```sh
./tools/lint-all.sh    # runs shellcheck on every .sh file
bats tests/            # runs the bats test suite
```

CI runs both on every push (see `.github/workflows/build.yml`).

## How to study effectively

Reading a shell tutorial gives you the illusion of understanding. Only writing and breaking scripts builds real skill. Do this loop per lesson:

1. **Read notes once** — top to bottom, don't stop to memorize.
2. **Run each example** — then modify one line and predict the result before running again. Reading tells you what should happen; running tells you what actually happens.
3. **Do exercises without notes open** — 30 minutes max per problem before peeking at the solution.
4. **Explain out loud** — pick one concept from the lesson and explain it to yourself (or a colleague). If you can't, you didn't learn it.
5. **Wait a day, then re-do exercise 1 from memory.** Spaced repetition beats one-shot cramming.

Aim for ~1 lesson per week if you're studying part-time. Faster is fine if the concepts land; slower is fine if they don't.

## Conventions this repo enforces

Every script in this repo — including examples and projects — follows these rules. Adopt them in your own work:

```sh
#!/usr/bin/env bash          # portable shebang
set -euo pipefail            # fail loud on errors, unset vars, pipe failures
IFS=$'\n\t'                  # (in robust scripts) don't split on spaces
```

- **Every runnable script has a bats test**, mirrored under `tests/`.
- **shellcheck must pass** at `--severity=warning`. `# shellcheck disable=...` only with a comment explaining why.
- **Commits reference the lesson**: `feat(learn/02): add sed portability example` or `fix(projects/backup-tool): atomic mv on same fs`.
- **Prose is bilingual (`en/` + `vi/`)**. Code and code comments stay in English so examples read the same regardless of language column.

## Contributing

- Fixing typos: PR straight to `main`.
- Adding a lesson: use `./tools/new-lesson.sh`, add both `en/` and `vi/`, update `learn/INDEX.md`.
- Adding a project: put it in `projects/<name>/`, self-contained (own README), and add tests under `tests/projects_<name>.bats`.
- Adding to `lib/`: it must have a test in `tests/lib_<name>.bats` before merging.

## Project status

- **[CHANGELOG.md](CHANGELOG.md)** — every version, what changed, when.
- **[ROADMAP.md](ROADMAP.md)** — planned lessons, projects, tools, and non-goals.

Current version: **0.1.0**. See CHANGELOG for what's shipped; see ROADMAP for what's next.

## References

Curated list in [`resources.md`](resources.md). Absolute must-reads:

- [Bash Pitfalls (Greg's Wiki)](https://mywiki.wooledge.org/BashPitfalls) — the shortcuts that will bite you.
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) — sensible defaults for teams.
- `man bash` — search `PARAMETERS`, `EXPANSION`, `REDIRECTION`, `SHELL BUILTIN COMMANDS`.

## License

See [`LICENSE`](LICENSE).
