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

## 3. YAML follows the same mental model

For simple config lookups, `yq` feels like `jq`:

```sh
yq -r '.app.port' config.yml
```

That is enough for a lot of shell automation where you need one or two config values and do not want a full language runtime.

## 4. Know when to stop

Shell + `jq` is great when:

- you need one field
- you are looping over a small array
- you are filtering API output in a pipeline

It gets unpleasant when:

- the JSON is deeply nested
- you need lots of branching logic
- you need real data structures across several stages

That is the point where Python becomes simpler than “clever shell.”

## Further reading
- `resources.md` for external references on `jq` and structured-data tooling.
- Future `lib/json.sh` and `lib/http.sh` items in `ROADMAP.md`.
