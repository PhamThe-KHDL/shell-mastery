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
[[ -d /opt/myapp ]] || mkdir -p /opt/myapp
id -u myapp &>/dev/null || useradd --system myapp
install -m0644 myapp.service /etc/systemd/system/myapp.service
systemctl daemon-reload
```
Each check is a guard; each install command is idempotent by nature.

## 5.
```sh
mv a.json a.json.swap
mv b.json a.json
mv a.json.swap b.json
```
`mv` on the same filesystem is atomic. Callers either see the old pair or the new pair — never a missing file.
