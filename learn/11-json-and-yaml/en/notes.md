# 11-json-and-yaml

## Goal
- Learn how modern shell scripts deal with structured data from APIs and config files.
- Know when `jq`/`yq` are enough and when the task has outgrown shell.

## 1. Do not parse JSON with `grep`

This is brittle:

```sh
curl ... | grep '"name"' | cut ...
```

JSON is structured data. Use `jq`:

```sh
curl -fsS URL | jq -r '.name'
```

That keeps quoting, escaping, and nesting rules correct.

## 2. `jq` is a filter language

Core patterns:

```sh
jq -r '.name'
jq -r '.items[]'
jq -r '.items[] | .id'
```

Think of `jq` as “select, transform, print” for JSON.

For shell scripts, `-r` is important because it prints raw strings instead of JSON-quoted strings.

You can feed `jq` from either a file or stdin:

```sh
jq -r '.name' payload.json
curl -fsS URL | jq -r '.items[] | .id'
```

That keeps your shell logic simple. Let `jq` own the JSON parsing; let the shell own the surrounding control flow.

## 3. Arrays and loops need care

This is the unsafe pattern:

```sh
for x in $(jq -r '.urls[]' file.json); do
    echo "$x"
done
```

Word splitting breaks as soon as an item contains spaces or tabs. Prefer line-based loops:

```sh
jq -r '.urls[]' file.json | while IFS= read -r url; do
    echo "checking $url"
done
```

This keeps each JSON element intact.

If you need several fields at once, make `jq` serialize them in a shell-friendly way:

```sh
jq -r '.items[] | [.name, .port] | @tsv' file.json |
while IFS=$'\t' read -r name port; do
    echo "$name listens on $port"
done
```

## 4. Missing data and failures matter

Real automation rarely gets perfect input. Decide what should happen when a key is missing:

```sh
jq -er '.token' config.json >/dev/null
```

With `-e`, `jq` exits non-zero when the filter result is false or null. That is often what you want in scripts that require a field to exist.

If missing data is acceptable, use defaults inside `jq`:

```sh
jq -r '.port // 8080' config.json
```

That keeps defaulting logic close to the data lookup.

## 5. YAML follows the same mental model

For simple config lookups, `yq` feels a lot like `jq`:

```sh
yq -r '.app.port' config.yml
```

This lesson assumes the widely used `mikefarah/yq` v4 syntax. Other `yq` implementations exist, and their flags/expressions are not interchangeable.

That is enough for a lot of shell automation where you need one or two config values and do not want a full language runtime.

Be careful with YAML complexity:

- indentation is structure
- strings like `yes`, `no`, or dates may be auto-typed
- multi-document YAML needs more deliberate filters

If the config format grows large, it is often cleaner to load it once in Python than to scatter `yq` calls through a long shell script.

## 6. Know when to stop

Shell + `jq` is great when:

- you need one field
- you are looping over a small array
- you are filtering API output in a pipeline

It gets unpleasant when:

- the JSON is deeply nested
- you need lots of branching logic
- you need real data structures across several stages

That is the point where Python becomes simpler than “clever shell.”

The practical boundary is this: use shell when JSON is just one step in a pipeline, not when JSON becomes your whole application state.

## Further reading
- `resources.md` for external references on `jq` and structured-data tooling.
- Future `lib/json.sh` and `lib/http.sh` items in `ROADMAP.md`.
