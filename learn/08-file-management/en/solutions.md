# Solutions 08-file-management

## 1. Find files by age

```bash
find "$dir" -type f -name '*.log' -mtime +7 -print
```

`-type f` avoids directories, `-name '*.log'` filters the extension, and `-mtime +7` means strictly older than 7 times 24 hours.

## 2. Create a safe archive

```bash
#!/usr/bin/env bash
set -euo pipefail

src=${1:?usage: archive-dir.sh DIR}
base=$(basename "$src")
parent=$(dirname "$src")
stamp=$(date -u +%Y%m%d)
out="${base}-${stamp}.tar.gz"

tar -C "$parent" -czf "$out" "$base"
echo "$out"
```

The key idea is `tar -C "$parent"`: it changes directory inside `tar`, not in the caller's shell, so your script does not disturb the user's working directory.

## 3. Copy only changed files

```bash
rsync -a --delete "$src"/ "$dest"/
```

`-a` preserves timestamps, permissions, and recursive structure. The trailing slash matters: `"$src"/` means "copy the contents of the directory." Add `--delete` only if you want the destination to become a true mirror.
