# topics

Cross-cutting reference material. Unlike `learn/` (linear course) or `cheatsheets/` (quick lookup), these are **deep dives** on subjects that touch every lesson.

Read them **when the lessons call them out** — not in advance, not all at once. Each is 200–400 lines of practical explanation with examples.

Each topic ships in both languages under `en/` and `vi/` subfolders (same shape as `learn/`). The `en` / `vi` links in the table below point at each.

## Available topics

| Topic | Languages | What it covers | Read this if |
|---|---|---|---|
| `quoting/` | [en](quoting/en/README.md) · [vi](quoting/vi/README.md) | Word splitting, `"$var"`, `"${arr[@]}"`, IFS. The #1 source of bugs. | You've ever thought "why did my script split my filename?" |
| `shellcheck/` | [en](shellcheck/en/README.md) · [vi](shellcheck/vi/README.md) | Install, editor integration, silencing, the 10 warnings you'll actually see | You want machine-checked feedback on every script you write |
| `debugging/` | [en](debugging/en/README.md) · [vi](debugging/vi/README.md) | `set -x`, `PS4`, `trap ERR`, common symptoms table | Your script does the wrong thing and you don't know why |
| `performance/` | [en](performance/en/README.md) · [vi](performance/vi/README.md) | Why fork is expensive, how to measure, when to leave shell | Your script is slow and you can't tell where |
| `portability/` | [en](portability/en/README.md) · [vi](portability/vi/README.md) | bash vs POSIX vs BSD tools, testing strategies | You're targeting Alpine, macOS, or "everywhere" |

## How they fit into the learning path

Each lesson references topics when relevant. Rough guide:

| Lesson | Topics that become useful |
|---|---|
| 01 – Basics | quoting (intro depth) |
| 02 – Text processing | shellcheck (start using it now) |
| 03 – Scripting fundamentals | quoting (all of it), shellcheck |
| 04 – I/O and processes | debugging |
| 05 – Robust scripts | debugging, performance |
| 06 – Advanced | portability, performance |
| 07 – Networking | portability, shellcheck |
| 08 – File management | quoting, portability |
| 09 – Processes | debugging, performance |
| 10 – Cron and scheduling | debugging, portability |
| 11 – JSON and YAML | shellcheck, portability |
| 12 – Dates and times | portability |
| 13 – Networking 2 | debugging, portability |
| 14 – Testing shell | shellcheck, debugging |

## Contributing a topic

Topics belong here when they:

- Are cross-cutting (touch multiple lessons).
- Deserve more than a cheatsheet's worth of prose.
- Have practical examples the reader will try, not just theory.

Structure a new topic like this:

```
topics/<slug>/
├── en/
│   └── README.md   # English version
└── vi/
    └── README.md   # Vietnamese version
```

Topics are bilingual: write `en/README.md` and mirror it in `vi/README.md`. The Vietnamese version should read naturally to a Vietnamese learner — explain the idea clearly, don't translate the English word-for-word. Keep the two in sync — if you change one, update the other in the same PR. Code, commands, and shellcheck codes stay in English in both.

When a topic grows big enough that readers need it repeatedly during the course, prefer linking to it from multiple lessons instead of duplicating the explanation inside each lesson.
