# References

Curated. Each item includes what it's for and when to reach for it. Not a link dump.

## Must-read (short list)

- **[Bash Pitfalls (Greg's Wiki)](https://mywiki.wooledge.org/BashPitfalls)** — a hall of shame of common mistakes. 40 short entries. Read one a day for a month; every entry is a bug you would have shipped.
- **[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)** — sensible defaults for a team. Not gospel, but disagreeing with it means you have a reason.
- **`man bash`** — the actual manual. Search for these sections: `EXPANSION` (variable and word expansion rules), `REDIRECTION`, `SHELL BUILTIN COMMANDS`, `SHELL GRAMMAR`. The prose is dense but authoritative.

## Reference documentation

- **[Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)** — the same content as `man bash` but linkable and searchable in a browser.
- **[POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)** — what's actually portable. Consult when writing `#!/bin/sh` or targeting Alpine/BusyBox.
- **[Bash Hackers Wiki](https://wiki.bash-hackers.org/)** — deeper explanations than `man bash`. Great for topics like process substitution, parameter expansion edge cases, and `IFS` behavior.

## Tools you should install

- **[shellcheck](https://www.shellcheck.net/)** — static analyzer. Catches the majority of common bash mistakes at write time. Install locally, set up your editor to run it, and add it to CI. Cost: 5 minutes. Benefit: enormous.
- **[shfmt](https://github.com/mvdan/sh)** — formatter. Removes bikeshedding about indentation. Run `shfmt -w -i 4 script.sh`.
- **[bats-core](https://github.com/bats-core/bats-core)** — test framework for bash. See this repo's `tests/` for examples. It's just bash with a runner; you'll learn it in 20 minutes.
- **[hyperfine](https://github.com/sharkdp/hyperfine)** — benchmark shell commands with warmup and stats. Use when you're optimizing.
- **[explainshell.com](https://explainshell.com/)** — paste any command; it explains every flag by parsing the man page. Great for reading unfamiliar one-liners.

## Books

- **The Linux Command Line** by William Shotts (free at [linuxcommand.org](https://linuxcommand.org/)) — the friendliest full introduction. If our lesson 1 feels too fast, start here.
- **Classic Shell Scripting** (Robbins & Beebe, O'Reilly) — dated (2005) but still the most solid treatment of portable shell.
- **Advanced Bash-Scripting Guide** (Cooper, at [tldp.org](https://tldp.org/LDP/abs/html/)) — free, encyclopedic, occasionally out of date. Search first, don't read cover to cover.

## Blogs, talks, video

- **Julia Evans' shell zines** ([wizardzines.com](https://wizardzines.com/)) — illustrated one-page explainers on `find`, `grep`, redirect, and more. Paid but cheap; excellent for visual learners.
- **Missing Semester** by MIT ([missing.csail.mit.edu](https://missing.csail.mit.edu/)) — one-hour lectures on shell, editors, git, etc. Lessons 2 and 5 map closely to our lessons 1 and 3.
- **Google Testing Blog: "Testing shell scripts"** — a good primer if bats feels unfamiliar.

## Community

- **[r/bash](https://reddit.com/r/bash)** — surprisingly high signal-to-noise. Good for design-question threads.
- **[Stack Overflow bash tag](https://stackoverflow.com/questions/tagged/bash)** — great for specific errors; check dates because old answers may use deprecated syntax.
- **`#bash` on Libera IRC** — for hard portability questions. The regulars are patient with beginners who show effort.

## When you're ready to leave shell

- **[Practical AWK](https://learnbyexample.github.io/learn_gnuawk/)** — awk fills the space between "one-liner" and "Python script". If your bash script has three awk stages, learn a bit more awk instead.
- **Python `subprocess` module** — the natural next step when scripts need real data structures. Pair with `sh`'s idioms you've internalized here.
