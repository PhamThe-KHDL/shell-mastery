# topics

Cross-cutting reference material. Unlike `learn/` (linear course) or `cheatsheets/` (quick lookup), these are **deep dives** on subjects that touch every lesson.

Read them **when the lessons call them out** — not in advance, not all at once. Each is 200–400 lines of practical explanation with examples.

## Available topics

| Topic | What it covers | Read this if |
|---|---|---|
| [`quoting/`](quoting/) | Word splitting, `"$var"`, `"${arr[@]}"`, IFS. The #1 source of bugs. | You've ever thought "why did my script split my filename?" |
| [`shellcheck/`](shellcheck/) | Install, editor integration, silencing, the 10 warnings you'll actually see | You want machine-checked feedback on every script you write |
| [`debugging/`](debugging/) | `set -x`, `PS4`, `trap ERR`, common symptoms table | Your script does the wrong thing and you don't know why |
| [`performance/`](performance/) | Why fork is expensive, how to measure, when to leave shell | Your script is slow and you can't tell where |
| [`portability/`](portability/) | bash vs POSIX vs BSD tools, testing strategies | You're targeting Alpine, macOS, or "everywhere" |

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

## Contributing a topic

Topics belong here when they:

- Are cross-cutting (touch multiple lessons).
- Deserve more than a cheatsheet's worth of prose.
- Have practical examples the reader will try, not just theory.

Structure a new topic like this:

```
topics/<slug>/
└── README.md       # everything lives here
```

Keep to English only in `topics/` — these are reference material, not primary learning content. The bilingual split lives in `learn/`.
