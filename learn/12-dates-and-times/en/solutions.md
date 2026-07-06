# Solutions 12-dates-and-times

## 1. Print an ISO 8601 timestamp

```bash
date -u +%Y-%m-%dT%H:%M:%SZ
```

`-u` forces UTC. The format string gives a stable ISO-like timestamp that sorts cleanly and travels well between systems.

## 2. Build a dated filename

```bash
stamp=$(date -u +%Y%m%d-%H%M%S)
echo "backup-${stamp}.tar.gz"
```

This format is compact, sortable, and safe in filenames because it avoids spaces and colons.

## 3. Compare two epoch values

```bash
a=1720000000
b=1720000060

if (( b > a )); then
    echo "later"
else
    echo "not later"
fi
```

Once both values are epoch seconds, there is nothing special left to do. Plain integer comparison is exactly the right tool.
