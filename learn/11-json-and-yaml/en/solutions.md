# Solutions 11-json-and-yaml

## 1. Extract one field from JSON

```bash
jq -r '.name' repo.json
```

Use `-r` so the output is plain text like `shell-mastery`, not JSON text like `"shell-mastery"`.

## 2. Loop over an array safely

```bash
jq -r '.[]' urls.json | while IFS= read -r url; do
    echo "$url"
done
```

The important choice is `while IFS= read -r`, not `for url in $(...)`. The loop stays correct even if a URL contains whitespace or odd characters.

## 3. Read one YAML config value

```bash
yq -r '.app.port' config.yml
```

This is the same basic pattern as `jq`: point at the nested field you want and print it in raw form for the surrounding shell script to use.
