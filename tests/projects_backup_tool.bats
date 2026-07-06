#!/usr/bin/env bats

BACKUP=projects/backup-tool/backup.sh

setup() {
    tmp=$(mktemp -d)
    src="$tmp/src"; dest="$tmp/dest"
    mkdir -p "$src" "$dest"
    echo "hello" > "$src/a.txt"
    echo "world" > "$src/b.txt"
}

teardown() {
    rm -rf "$tmp"
}

@test "missing required flags: exit 2" {
    run "$BACKUP"
    [ "$status" -eq 2 ]
}

@test "missing option value: exit 2" {
    run "$BACKUP" -s
    [ "$status" -eq 2 ]
}

@test "runs and creates one archive" {
    run "$BACKUP" -s "$src" -d "$dest" -n mybak
    [ "$status" -eq 0 ]
    n=$(find "$dest" -maxdepth 1 -name 'mybak-*.tar.gz' | wc -l | tr -d ' ')
    [ "$n" -eq 1 ]
}

@test "supports --flag=value syntax" {
    run "$BACKUP" --source="$src" --dest="$dest" --name=mybak
    [ "$status" -eq 0 ]
}

@test "archive contains the source files" {
    run "$BACKUP" -s "$src" -d "$dest" -n mybak
    [ "$status" -eq 0 ]
    archive=$(find "$dest" -maxdepth 1 -name 'mybak-*.tar.gz' | head -1)
    run tar -tzf "$archive"
    [[ "$output" == *"a.txt"* ]]
    [[ "$output" == *"b.txt"* ]]
}

@test "retention keeps only KEEP archives" {
    # fabricate 5 old archives + 1 real → should trim to 3
    for i in 1 2 3 4 5; do
        touch "$dest/mybak-2024010${i}-000000.tar.gz"
    done
    run "$BACKUP" -s "$src" -d "$dest" -n mybak -k 3
    [ "$status" -eq 0 ]
    n=$(find "$dest" -maxdepth 1 -name 'mybak-*.tar.gz' | wc -l | tr -d ' ')
    [ "$n" -eq 3 ]
}

@test "dry-run doesn't create anything" {
    run "$BACKUP" -s "$src" -d "$dest" -n mybak --dry-run
    [ "$status" -eq 0 ]
    n=$(find "$dest" -maxdepth 1 -name 'mybak-*.tar.gz' | wc -l | tr -d ' ')
    [ "$n" -eq 0 ]
}

@test "rejects non-existent source" {
    run "$BACKUP" -s /nope -d "$dest" -n mybak
    [ "$status" -eq 1 ]
}
