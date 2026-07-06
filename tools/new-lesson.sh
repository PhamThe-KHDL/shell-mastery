#!/usr/bin/env bash
set -euo pipefail

# Scaffold a new lesson under learn/.
# Usage: ./tools/new-lesson.sh <slug>
# Example: ./tools/new-lesson.sh 07-networking
#
# Shape created:
#   learn/<slug>/
#   ├── en/{notes,exercises,solutions}.md
#   ├── vi/{notes,exercises,solutions}.md
#   └── examples/01-hello.sh

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <slug>" >&2
    echo "Example: $0 07-networking" >&2
    exit 2
fi

slug=$1
root=$(cd "$(dirname "$0")/.." && pwd)
dir="$root/learn/$slug"

if [[ -e $dir ]]; then
    echo "❌ Already exists: $dir" >&2
    exit 1
fi

mkdir -p "$dir/en" "$dir/vi" "$dir/examples"

# --- English ---
cat > "$dir/en/notes.md" <<EOF
# $slug

## Goal
- TODO

## Content
TODO

## Further reading
- TODO
EOF

cat > "$dir/en/exercises.md" <<EOF
# Exercises $slug

Try each on your own, then check [\`solutions.md\`](solutions.md).

## 1. TODO
EOF

cat > "$dir/en/solutions.md" <<EOF
# Solutions $slug

## 1.
TODO
EOF

# --- Vietnamese ---
cat > "$dir/vi/notes.md" <<EOF
# $slug

## Mục tiêu
- TODO

## Nội dung
TODO

## Đọc thêm
- TODO
EOF

cat > "$dir/vi/exercises.md" <<EOF
# Bài tập $slug

Làm xong đối chiếu với [\`solutions.md\`](solutions.md).

## 1. TODO
EOF

cat > "$dir/vi/solutions.md" <<EOF
# Lời giải $slug

## 1.
TODO
EOF

# --- Shared examples ---
cat > "$dir/examples/01-hello.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "hello from example"
EOF
chmod +x "$dir/examples/01-hello.sh"

echo "✅ Created $dir"
echo "👉 Remember to add a row to learn/INDEX.md"
