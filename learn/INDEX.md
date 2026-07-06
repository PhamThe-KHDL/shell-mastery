# Learning Index

This is the main entry point. Read this page first — it explains the study order, the study loop, what each lesson depends on, and how long each one takes.

## Prerequisites

Before lesson 1:

- Comfortable opening a terminal (`Terminal.app`, iTerm2, `gnome-terminal`, WSL, whatever you have).
- Basic idea of what a file and a directory are.
- **No prior shell knowledge required.**

Optional but recommended: install `shellcheck` — it will catch beginner mistakes in real time (`brew install shellcheck` on macOS, `apt install shellcheck` on Debian).

## Study path (in order)

Each folder is a slug — the number is just for sort order. Inserting a lesson later doesn't renumber anything; only this file changes.

| # | Lesson | English | Vietnamese | ~Time | Depends on |
|---|---|---|---|---|---|
| 1 | Basics — cd, ls, pipes, redirect, quoting | [en](01-basics/en/notes.md) | [vi](01-basics/vi/notes.md) | 2h | — |
| 2 | Text processing — grep, sed, awk, cut, sort, uniq | [en](02-text-processing/en/notes.md) | [vi](02-text-processing/vi/notes.md) | 3h | 1 |
| 3 | Scripting fundamentals — variables, if, loops, functions, exit codes | [en](03-scripting-fundamentals/en/notes.md) | [vi](03-scripting-fundamentals/vi/notes.md) | 3h | 1, 2 |
| 4 | I/O and processes — subshell, xargs, trap, signals, jobs | [en](04-io-and-processes/en/notes.md) | [vi](04-io-and-processes/vi/notes.md) | 3h | 3 |
| 5 | Robust scripts — `set -euo pipefail`, IFS, error handling | [en](05-robust-scripts/en/notes.md) | [vi](05-robust-scripts/vi/notes.md) | 2h | 3, 4 |
| 6 | Advanced — arrays, associative arrays, parameter expansion, coproc | [en](06-advanced/en/notes.md) | [vi](06-advanced/vi/notes.md) | 3h | 3, 5 |
| 7 | Networking — `curl`, `ssh`, `scp`, DNS, ports | [en](07-networking/en/notes.md) | [vi](07-networking/vi/notes.md) | 2h+ | 3, 5 |
| 8 | File management — `find`, `tar`, `rsync`, safe delete | [en](08-file-management/en/notes.md) | [vi](08-file-management/vi/notes.md) | 2h+ | 2, 5 |
| 9 | Processes — inspect, signal, background, priority | [en](09-processes/en/notes.md) | [vi](09-processes/vi/notes.md) | 2h+ | 4, 5 |
| 10 | Cron and scheduling — cron, timers, `flock` | [en](10-cron-and-scheduling/en/notes.md) | [vi](10-cron-and-scheduling/vi/notes.md) | 2h+ | 5, 9 |
| 11 | JSON and YAML — `jq`, `yq`, structured data boundaries | [en](11-json-and-yaml/en/notes.md) | [vi](11-json-and-yaml/vi/notes.md) | 2h+ | 2, 3 |
| 12 | Dates and times — GNU/BSD `date`, epoch, UTC | [en](12-dates-and-times/en/notes.md) | [vi](12-dates-and-times/vi/notes.md) | 1.5h+ | 5 |
| 13 | Networking 2 — tunnels, proxies, `nc` workflows | [en](13-networking-2/en/notes.md) | [vi](13-networking-2/vi/notes.md) | 2h+ | 7 |
| 14 | Testing shell — bats, fixtures, failure-path tests | [en](14-testing-shell/en/notes.md) | [vi](14-testing-shell/vi/notes.md) | 2h+ | 3, 5 |

All fourteen lessons are present in-tree with notes, exercises, solutions, and runnable examples.

The first six lessons are about ~16 hours of study material on their own. The full 14-lesson track is materially larger. Add another ~10 hours of exercises + tinkering to actually internalize the early core, and more if you work through the full track carefully.

## Anatomy of a lesson

```
NN-topic/
├── en/
│   ├── notes.md          # concepts, patterns, and syntax reference
│   ├── exercises.md      # usually 3–5 problems, no answers
│   └── solutions.md      # reference answers with code and short explanations
├── vi/                   # same three files, translated
└── examples/             # runnable scripts, shared, English comments
    ├── 01-*.sh
    ├── 02-*.sh
    └── 03-*.sh
```

Pick one language folder (`en/` or `vi/`) and stay there for the whole lesson. The examples are shared — comments are always in English so the code reads consistently.

## The study loop (per lesson)

Reading a shell tutorial gives you the illusion of understanding. Only running and breaking scripts builds real skill. For each lesson:

1. **Read notes once, top to bottom.** Don't try to memorize. If a concept is unclear, mark it and move on — it usually clicks after the examples.
2. **Run each example.** Then change one line, predict the output, and run again. The gap between prediction and reality is where you actually learn.
3. **Attempt each exercise from scratch.** No peeking at solutions for at least 30 minutes per problem. Frustration is part of the process; write down what you tried.
4. **Compare to the solution.** Not just "was I right?" — read the solution's approach and ask whether yours would still work at scale (bigger input, weirder filenames, missing files).
5. **Explain one concept out loud.** Pick the trickiest thing from the lesson and explain it to yourself in your own words. If you can't, re-read that section.
6. **Update the status column below.** Small but powerful — makes progress visible.

Wait a day, then redo one exercise from memory before moving on. Spaced repetition beats one-shot cramming.

## Your progress tracker

This section is for **your** progress as a reader — separate from the lesson table above, which describes the curriculum itself rather than your personal completion state.

Legend: 🟢 done · 🟡 in progress · ⚪ not started · 🔵 revisiting

Update the emoji per lesson as you go. If the repo is your fork, commit it — your git history becomes your study log.

| # | Lesson | Your status |
|---|---|---|
| 1 | Basics | ⚪ |
| 2 | Text processing | ⚪ |
| 3 | Scripting fundamentals | ⚪ |
| 4 | I/O and processes | ⚪ |
| 5 | Robust scripts | ⚪ |
| 6 | Advanced | ⚪ |
| 7 | Networking | ⚪ |
| 8 | File management | ⚪ |
| 9 | Processes | ⚪ |
| 10 | Cron and scheduling | ⚪ |
| 11 | JSON and YAML | ⚪ |
| 12 | Dates and times | ⚪ |
| 13 | Networking 2 | ⚪ |
| 14 | Testing shell | ⚪ |

## Cross-cutting topics

Read these when the lesson calls them out — not in advance, not all at once:

- [topics/quoting](../topics/quoting/README.md) — quoting and word splitting. Referenced from lesson 1; deeper questions arise in 3–6.
- [topics/shellcheck](../topics/shellcheck/README.md) — how to read shellcheck warnings. Start using shellcheck from lesson 3.
- [topics/debugging](../topics/debugging/README.md) — `set -x`, `PS4`, `trap ERR`. First useful in lesson 4.
- [topics/portability](../topics/portability/README.md) — bash vs POSIX vs BSD tools. Relevant when your scripts need to run on servers or Alpine containers.
- [topics/performance](../topics/performance/README.md) — when shell is slow, when to switch to `awk`/Python. Read after lesson 4.

## After the core path

Once you finish lesson 6, you already have the core habits needed to read and build real shell scripts. Then:

1. **Read the projects.** [`projects/backup-tool`](../projects/backup-tool/) and [`projects/log-analyzer`](../projects/log-analyzer/) are real, tested scripts. Read them like case studies — how they parse arguments, handle errors, structure functions.
2. **Read [`tests/README.md`](../tests/README.md).** It complements lesson 14 with worked examples from the actual repo and shows how the test tree mirrors `lib/` and `projects/`.
3. **Rewrite one of the bats suites** in your own style, then compare. Different test shapes teach you as much as one polished version.
4. **Add a project of your own.** Pick something you'd actually use (a `gh` wrapper, a rsync-based backup, a log-tailer) and put it in `projects/<yours>/`.
5. **Rescue a bash script you already have.** Add strict mode, add tests, run shellcheck. Compare before/after.

If you continue through the full 14-lesson track, this is also where lessons 7-14 start paying off heavily: networking, file-management, scheduling, JSON/YAML, dates, and testing stop being separate topics and become part of real script design.

## FAQ

**Do I need to do the exercises?**
Yes. Reading without practice = watching gym videos without lifting.

**English or Vietnamese notes?**
Whichever you're most comfortable in. The content is identical; the code is shared. Nothing stops you reading English first for a lesson, then Vietnamese for another.

**How long should each lesson take?**
The "~Time" column is passive reading + example running. Add 50–100% for exercises. Don't rush lesson 5 — strict mode changes how you think about failure.

**I finished lesson 3 but I'm confused by lesson 4's subshells.**
That's expected. Subshells confuse everyone the first time. Re-run `learn/04-io-and-processes/examples/03-subshell-bug.sh` and predict each result before running. If still stuck, read `topics/debugging` and re-run with `set -x`.

**Can I skip lessons I already know?**
Sure. But do the exercises anyway — they surface the gaps you didn't know you had.

**Where do I learn bats testing in a structured way?**
Start with [`14-testing-shell`](14-testing-shell/en/notes.md) or its [Vietnamese version](14-testing-shell/vi/notes.md), then read [`tests/README.md`](../tests/README.md) and the actual bats files under `tests/` to see the lesson applied to real repo code.
