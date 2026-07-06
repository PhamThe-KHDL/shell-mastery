# cheatsheets

Quick lookup, one page per topic. No prose — just commands, forms, and traps.

Use these when:

- You **know** what you want to do; you just forgot the exact syntax.
- You're writing a script and want a scan-able reference in one keystroke.
- You're reviewing code and want to sanity-check an unfamiliar `awk` expression.

If you don't know what you want, go to [`learn/`](../learn/) or [`topics/`](../topics/) — those explain concepts. Cheatsheets don't teach; they remind.

If you are a beginner, treat a cheatsheet as the second stop, not the first:

1. learn the concept in `learn/`
2. read the fuller explanation in `topics/` if needed
3. come back here once you only need syntax recall

## Available cheatsheets

| File | Covers |
|---|---|
| [`redirect.md`](redirect.md)               | `>`, `>>`, `2>`, `&>`, here-docs, here-strings, `tee`, common stderr merge traps |
| [`grep.md`](grep.md)                       | Match modes, context lines, recursion, includes/excludes, quiet mode |
| [`sed.md`](sed.md)                         | Substitution, addresses, deletion, multi-command, portable in-place edits |
| [`awk.md`](awk.md)                         | Fields, filters, aggregates, joins, unique-preserving-order |
| [`arrays.md`](arrays.md)                   | Indexed and associative arrays, iteration, mapfile, common quoting traps |
| [`parameter-expansion.md`](parameter-expansion.md) | `${var:...}` — defaults, substrings, prefix/suffix strip, substitution, case, length |
| [`test.md`](test.md)                       | `[ ]`, `[[ ]]`, `(( ))` — file tests, string tests, integer tests |

## Suggested printing

If you learn better with paper next to your keyboard, print `redirect.md`, `parameter-expansion.md`, `arrays.md`, and `test.md`. Those four cover the syntax you'll forget most often in the first six months.

## Suggested reading order (if you insist)

Cheatsheets aren't meant to be read in order, but if you're new:

1. `test.md` — you'll write `if [[ ... ]]` before anything else.
2. `redirect.md` — makes pipelines make sense.
3. `parameter-expansion.md` — the string-op superpower.
4. `grep.md` → `sed.md` → `awk.md` — the classic text-processing trio.
5. `arrays.md` — once you're writing real scripts.

## Contributing

- One page per file. No sub-headers below `##`.
- Every example must actually work — copy into a terminal and verify before committing.
- No prose beyond a one-line note next to each item.
- Highlight traps with `**Pitfall**:` at the bottom.

Good cheatsheet additions are things readers need to look up repeatedly. If a contribution mainly explains why something works, it probably belongs in `learn/` or `topics/` instead.
