# Solutions 05 · Robust scripts

## 1.
Without `pipefail`, `grep`'s failure is masked by `wc -l` returning 0. The script prints `0 matches` and exits 0 — a silent lie.

Fix:
```sh
#!/usr/bin/env bash
set -euo pipefail
count=$(grep -c foo huge.log)     # -c avoids the pipeline entirely
echo "$count matches"
```
Or keep the pipeline but add `set -o pipefail`.

## 2.
```sh
#!/usr/bin/env bash
set -euo pipefail
: "${DB_URL:?DB_URL is required}"
: "${API_KEY:?API_KEY is required}"
# ... work ...
```

## 3.
```sh
dry_run=0
[[ ${1:-} == --dry-run ]] && { dry_run=1; shift; }

run() { (( dry_run )) && echo "DRY: $*" || "$@"; }

run rm -rf /some/path
run systemctl restart myapp
```

## 4.
```sh
#!/usr/bin/env bash
set -euo pipefail

install -d -m0755 /opt/myapp

if ! id -u myapp >/dev/null 2>&1; then
    useradd --system --home /opt/myapp --shell /usr/sbin/nologin myapp
fi

unit=/etc/systemd/system/myapp.service
if ! cmp -s myapp.service "$unit"; then
    install -m0644 myapp.service "$unit"
    systemctl daemon-reload
fi
```
`install -d` is safe to rerun, the user is only created if missing, and `daemon-reload` only runs when the unit file actually changed. That makes the second run a real no-op when the machine is already in the desired state.

## 5.
```sh
mv a.json a.json.swap
mv b.json a.json
mv a.json.swap b.json
```
This is the shortest practical swap, but it is **not** truly atomic as a pair. Each individual same-filesystem `mv` is atomic, yet the three-step sequence still has intermediate states where callers can observe partially swapped names.

With only bash + `mv`, a true two-path atomic swap is not available. To make the overall operation atomic, you need a different interface such as:

- one stable symlink that points at versioned files, then atomically replace the symlink target
- one parent directory that gets swapped with a single rename
- a tool or filesystem primitive that supports exchange-style renames
