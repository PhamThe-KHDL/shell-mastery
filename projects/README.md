# projects

Real, tested, self-contained bash scripts. Not lesson material — read them like case studies once you've finished the `learn/` track.

Each project lives in its own folder with:

- `README.md` — what it does, how to run, sample output, failure modes.
- The script(s) themselves — following every convention this repo enforces.
- Tests in `tests/projects_<name>.bats` (mirrored from the project name).

## Available projects

| Project | Description | Skills demonstrated |
|---|---|---|
| [`backup-tool/`](backup-tool/) | Timestamped atomic tar+gzip backups with retention | `getopts`/long-args, `trap`, atomic `mv`, `mapfile`, dry-run pattern, input validation |
| [`log-analyzer/`](log-analyzer/) | Summarize Combined Log Format access logs from stdin or a file | pipeline composition, `awk` aggregation, stdin fallback, temp file cleanup |

## How to read a project

1. **Read the README first.** Understand what problem it solves and how it's used.
2. **Run it on the fixture data** (the tests are a good source of realistic inputs).
3. **Read the script from bottom to top.** Real scripts often make more sense in reverse — you see the final action, then trace back to how it was prepared.
4. **Look for the safety features.** Where does it validate input? Where does it clean up? What does it do when someone hits Ctrl-C halfway?
5. **Read the tests.** They document intended behavior more precisely than prose.
6. **Change one thing.** Break something on purpose, rerun the tests. If nothing fails, the tests are inadequate — good learning too.

## Adding your own project

```sh
mkdir -p projects/my-thing
touch projects/my-thing/{README.md,my-thing.sh}
touch tests/projects_my_thing.bats
chmod +x projects/my-thing/my-thing.sh
```

Follow the pattern:

- Script starts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- `usage()` function, exit code 2 on misuse.
- Input validation before any real work.
- `trap` for cleanup if you touch temp files.
- At least one bats test per code path (happy path, missing input, invalid flag, edge case).

Run `./tools/lint-all.sh` and `bats tests/projects_my_thing.bats` before committing.

## Ideas for projects to attempt

If you've finished the lessons and want to practice on your own:

- **`dotfiles-installer`** — idempotent, backs up existing configs before symlinking.
- **`gh-repo-audit`** — clone every repo in a GitHub org, count lines by language, output CSV.
- **`prometheus-scraper`** — cron-friendly script that curls a Prometheus endpoint, extracts specific metrics, writes to a rotating log.
- **`disk-usage-alert`** — check filesystem usage, email/notify if a threshold is crossed, don't re-alert within N hours.
- **`ssh-tunnel-supervisor`** — bring up an SSH tunnel, restart it if it dies, exit cleanly on SIGTERM.

Each of these exercises a distinct combination of skills from lessons 3–6. Write it, test it, then read this repo's projects and see what you'd change.
