# Solutions 11-json-and-yaml

## 1.
Start with `jq -r '.name' file.json`.

## 2.
Use `jq -r '.[]'` and read line-by-line rather than flattening JSON into words.

## 3.
For YAML, `yq -r '.app.port' config.yml` is the same mental model as `jq`.
