# snippets

Copy-paste starting points. These are **not sourceable libraries** — they're templates you paste into a new script and adapt. Nothing here is tested, because there's no fixed interface to test.

If a snippet stabilizes and you find yourself pasting it into three scripts, promote it to `lib/` with a bats test. That's the graduation path.

## Available snippets

| File | For | Key idea |
|---|---|---|
| [`getopts.sh`](getopts.sh)  | Scripts with short flags like `-v -n NAME -c 5` | Uses bash's built-in `getopts`. No external dependencies. Handles unknown flags, missing arguments, and shows a proper `usage()`. |
| [`argparse.sh`](argparse.sh) | Scripts that need long flags like `--verbose --name alice --count=5` | Manual `case` parser because `getopts` doesn't do long options. Supports `--name VAL` and `--name=VAL` forms. |

## When to pick which

- **Short flags only** — `getopts`. Fewer lines, universally understood, well-tested by billions of scripts.
- **You want `--long-options`** — `argparse`. Slightly more code, but users get the modern CLI feel.
- **You want both** — copy `argparse` and add short-flag branches inside the same `case`. The `backup-tool` project does this — read its argument parser for the pattern.

## Using a snippet

1. Copy the file's contents into your new script.
2. Delete lines you don't need (e.g. remove the `--count` handling if your script has no count).
3. Rename variables to match your domain.
4. Add validation for required flags.
5. Delete the trailing `# ... your logic here ...` placeholder and start writing.
6. Run `shellcheck` on the new script before you trust the snippet adaptation.
7. If the same adapted shape appears in several scripts, stop copying and promote it into `lib/`.

## Editing checklist after paste

The biggest beginner mistake with templates is leaving in assumptions from the original snippet. Before calling the script "done", check:

- Did you rename every variable so it matches your domain?
- Did you remove options you do not actually support?
- Did you add required-input validation near the top?
- Did you update `usage()` so the help text matches reality?
- Did you test one success path and one misuse path?

## Not everything belongs here

Snippets are for **structural boilerplate** — the shape of a script that would look the same in any project. Domain-specific code (parsing your company's log format, calling a specific API) belongs in a project, not here.

If you write a lot of similar scripts and want a base template, keep your own local snippets folder outside this repo. This one is scoped to genuinely reusable patterns.

## Ideas to add

- `strict-header.sh` — the `#!/usr/bin/env bash; set -euo pipefail; IFS=$'\n\t'; trap ERR` opening block.
- `tmpdir.sh` — inline (non-library) tempdir + trap pattern. Different from `lib/tempdir.sh` because you don't want a dependency.
- `require-cmd.sh` — check that a list of commands is on `$PATH` before starting real work.
- `parse-env.sh` — required-env-var guard using `${VAR:?message}`.
