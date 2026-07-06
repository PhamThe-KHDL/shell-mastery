# 12-dates-and-times

## Goal
- Learn the date/time operations that routinely break scripts across platforms.
- Practice producing predictable timestamps, parsing input, and handling time zones carefully.

## 1. Use sortable formats

For filenames and logs, choose formats that sort lexicographically the same way they sort chronologically:

```sh
date -u +%Y%m%d-%H%M%S
date -u +%Y-%m-%dT%H:%M:%SZ
```

Those are much easier to work with than locale-dependent formats.

Avoid formats like `07/06/26 2:30 PM` in automation. They are ambiguous for humans and annoying for scripts.

## 2. GNU vs BSD `date` is a real portability trap

macOS uses BSD `date`; most Linux systems use GNU `date`.
The formatting flags are similar, but relative-date operations often differ.

That means:

- simple formatting is usually portable
- parsing and “N days ago” logic often is not

If you need portable date arithmetic, isolate it carefully or move it into a helper/library.

Formatting is usually fine:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Relative arithmetic is where things split:

```sh
date -d 'yesterday'              # GNU
date -v-1d                      # BSD/macOS
```

That difference alone is why many shell repos either avoid date math or wrap it behind a helper function.

## 3. Epoch is the universal comparison format

When comparing times in shell, epoch seconds are easiest:

```sh
a=$(date +%s)
b=$((a + 60))

if (( b > a )); then
    echo later
fi
```

Human-readable strings are for logs. Epoch numbers are for arithmetic.

This applies to age checks too:

```sh
now=$(date +%s)
cutoff=$((now - 3600))
```

Once everything is numeric, plain shell arithmetic works.

## 4. Prefer UTC in automation

Local time is for humans. UTC is for systems.

Scheduled jobs and logs are easier to debug when they use UTC:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

That avoids DST surprises and “which timezone was this server using?” confusion.

If humans need local time, convert once at the boundary where you display or email the result.

## 5. Filenames and logs want different timestamp shapes

For filenames:

```sh
stamp=$(date -u +%Y%m%d-%H%M%S)
out="backup-${stamp}.tar.gz"
```

For logs:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Both are sortable. The filename form avoids colons and spaces; the log form is easier for humans and for external tools that expect ISO 8601.

## 6. Parse input once, then normalize

If a script accepts a user-supplied timestamp, convert it immediately into the form you will compare:

- epoch if you need math
- UTC ISO 8601 if you need a stable interchange format

Do not keep converting back and forth through several different layouts unless you enjoy debugging timezone mistakes.

## Further reading
- `topics/portability` because date handling is one of the most platform-sensitive areas.
- Future `lib/dates.sh` in `ROADMAP.md`.
