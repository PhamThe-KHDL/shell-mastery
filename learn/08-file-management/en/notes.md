# 08-file-management

## Goal
- Learn the file-manipulation commands that make shell scripts genuinely useful.
- Practice selecting files safely, archiving them, and copying them without footguns.

## 1. `find` is the real file-selection language

Beginners often reach for `for f in $(ls ...)`; that breaks on spaces and scales poorly.
Use `find` instead:

```sh
find logs/ -type f -name '*.log'
find . -type f -mtime +7
find src/ -type f -size +10M
```

When feeding results to another command, prefer null-delimited pipelines:

```sh
find . -type f -print0 | xargs -0 rm -f
```

That is the standard defense against weird filenames.

## 2. Quote paths and use `--`

For file commands, quoting is not optional:

```sh
cp "$src" "$dest"
mv "$tmp" "$final"
rm -- "$file"
```

`--` matters when a filename might begin with `-`. Without it, a filename can be misread as a flag.

## 3. Archive without changing the caller's directory

This is a common safe pattern:

```sh
tar -C "$(dirname "$src")" -czf "$out" "$(basename "$src")"
```

Why it is better than `cd "$src"; tar ...`:

- it does not mutate shell state
- it works from any current directory
- it is easier to wrap in scripts and tests

## 4. `rsync` is the copy tool you eventually want

For directory mirroring, `rsync -a` is usually the right default:

```sh
rsync -a src/ dest/
```

It preserves timestamps and permissions and only copies what changed. That makes it better than repeated `cp -r` for backups or deploy-style syncs.

## 5. Safe deletion mindset

The dangerous part of file-management scripts is rarely copying; it is deleting.

Before any bulk delete:

1. print what would be removed
2. filter as narrowly as possible
3. prefer `find ... -type f` over broad globs
4. add a dry-run mode when deletion is non-trivial

This is exactly why robust backup/cleanup scripts grow `--dry-run`.

## Further reading
- `projects/backup-tool` as a worked example of archive creation and retention.
- `topics/portability` for BSD vs GNU `find`/`tar` differences.
