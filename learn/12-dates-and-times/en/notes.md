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

## 2. GNU vs BSD `date` is a real portability trap

macOS uses BSD `date`; most Linux systems use GNU `date`.
The formatting flags are similar, but relative-date operations often differ.

That means:

- simple formatting is usually portable
- parsing and “N days ago” logic often is not

If you need portable date arithmetic, isolate it carefully or move it into a helper/library.

## 3. Epoch is the universal comparison format

When comparing times in shell, epoch seconds are easiest:

```sh
if (( b > a )); then
    echo later
fi
```

Human-readable strings are for logs. Epoch numbers are for arithmetic.

## 4. Prefer UTC in automation

Local time is for humans. UTC is for systems.

Scheduled jobs and logs are easier to debug when they use UTC:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

That avoids DST surprises and “which timezone was this server using?” confusion.

## Further reading
- `topics/portability` because date handling is one of the most platform-sensitive areas.
- Future `lib/dates.sh` in `ROADMAP.md`.
