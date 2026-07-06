# Lời giải 11-json-and-yaml

## 1.
Bắt đầu với `jq -r '.name' file.json`.

## 2.
Dùng `jq -r '.[]'` rồi đọc theo từng dòng, đừng flatten JSON thành word list.

## 3.
Với YAML, `yq -r '.app.port' config.yml` dùng cùng mental model với `jq`.
