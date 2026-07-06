# Solutions 08-file-management

## 1.
Start with `find DIR -type f -name '*.log' -mtime +7`.

## 2.
Use `tar -C "$(dirname "$src")" -czf "$out" "$(basename "$src")"`.

## 3.
`rsync -a SRC/ DEST/` is the default safe starting point for incremental copies.
