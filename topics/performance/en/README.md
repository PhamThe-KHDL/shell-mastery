# Topic · Performance

> 🌐 **English** · [Tiếng Việt](../vi/README.md)

Shell is fast for glue, slow for computation. Knowing which side of that line you're on decides whether "shell script" is the right tool for your job.

The single most valuable thing on this page: **fork is expensive.** Once that sinks in, everything else follows.

## The mental model

Every command that isn't a bash builtin costs ~1–3 ms of fork + exec on Linux. Doesn't sound like much? A loop that calls `sed` on 10,000 lines just paid 10,000 × 3 ms = **30 seconds** of pure process-creation overhead — before any actual work.

The same 10,000 lines processed by one `sed` invocation take a few hundred **milliseconds** total, because it's one fork and streaming I/O.

## Order-of-magnitude table

Rough numbers on a modern laptop, ignoring cache effects:

| Operation | Time per call |
|---|---|
| Bash builtin (`[[`, `echo`, arithmetic, parameter expansion) | ~1 µs |
| Fork + exec of a small binary (`ls`, `grep`, `sed`) | 1–3 ms |
| Fork + exec of Python interpreter | 30–80 ms |
| Fork + exec of Node.js | 80–200 ms |
| One line through a running pipeline | I/O bound |

Rule of thumb: **if your loop spawns 100+ processes, refactor.** Under 100, worry about correctness, not speed.

## Cheap wins

### 1. Replace loops with `awk`, `sed`, or `grep`

The classic case:

```sh
# ❌ 10,000 processes for a 10,000-line file
while IFS= read -r line; do
    echo "$line" | sed 's/foo/bar/'
done < file

# ✅ 1 process
sed 's/foo/bar/' file
```

The awk / sed / grep tools each read the whole stream in a single process. Even complex logic often fits.

### 2. Use built-in string operations, not `basename`/`dirname`/`cut`

```sh
# ❌ 1 process per iteration
name=$(basename "$path")

# ✅ 0 processes
name=${path##*/}
```

Parameter expansion is a bash builtin. See [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md).

### 3. Skip useless `cat`

```sh
cat file | grep foo         # ❌ extra fork
grep foo file               # ✅
grep foo < file             # ✅
```

The "useless use of cat" award is a real thing. It's not just aesthetic; each `cat` costs a fork.

### 4. Batch commands with `xargs -exec {} +` or `find ... -exec {} +`

```sh
# ❌ 1000 rm processes
find . -name '*.tmp' -exec rm {} \;

# ✅ 1 rm process (or a few, batched)
find . -name '*.tmp' -exec rm {} +
find . -name '*.tmp' -print0 | xargs -0 rm
```

The `+` (vs `\;`) form of `-exec` batches arguments to hit the max command-line length, dramatically reducing fork count.

### 5. Parallelize independent work

`xargs -P N` runs up to N invocations concurrently:

```sh
# 8 curl processes at once, one per URL from urls.txt
xargs -P8 -n1 -I{} curl -sI {} < urls.txt
```

Or with background jobs and `wait`:

```sh
for host in a b c d; do
    ping -c1 "$host" &
done
wait
```

See [`learn/04-io-and-processes`](../../../learn/04-io-and-processes/en/notes.md) for the full pattern.

### 6. Avoid subshells when unnecessary

Every `( ... )` and `$(...)` is a subshell — a fork. Sometimes worth it (isolating `cd`, capturing output), often not (`echo "$(echo hi)"` is just `echo hi`).

## Measure before optimizing

### Wall-clock

```sh
time ./slow.sh
```

### Section timing

```sh
t0=$SECONDS
big_thing
echo "big_thing took $((SECONDS - t0))s" >&2

t0=$SECONDS
another_thing
echo "another_thing took $((SECONDS - t0))s" >&2
```

`$SECONDS` is a bash built-in; incrementing since shell start. Cheap to sample.

### Microbenchmarking

For serious comparisons, use [hyperfine](https://github.com/sharkdp/hyperfine):

```sh
hyperfine --warmup 3 './old.sh' './new.sh'
```

It runs each command multiple times, discards warm-up runs (caches), and shows mean ± stddev with statistical significance.

## Anti-patterns to unlearn

| Anti-pattern | Cost | Fix |
|---|---|---|
| `for f in $(ls *.log)` | 1 process, word-split bug | `for f in *.log` |
| `cat file \| grep foo` | 1 extra fork | `grep foo file` |
| `basename "$p"` in a loop | N forks | `${p##*/}` |
| `echo "$x" \| tr A-Z a-z` | N forks | `${x,,}` (bash 4+) |
| `sed 's/x/y/' <<< "$var"` | 1 fork | `${var/x/y}` |
| Sleeping to wait for a file | wasted seconds | `inotifywait` or poll with `[[ -e ]]` |

## When to leave shell

You've outgrown shell when:

- Your data is bigger than a few 100 MB and you're processing line-by-line.
- You need real data structures (map of arrays of records).
- Your bottleneck is CPU (regex on huge strings, math, sorting large data structures).
- You're doing anything with floating point (bash integer-only).

At that point:

- **`awk`** is the natural first upgrade — same "one process, streams input" model but with real variables and arrays.
- **Python** is the second — real types, exceptions, huge stdlib. `subprocess` lets you keep shelling out for what shell is good at.
- **Go** or **Rust** is the third — when startup time matters and you want a single binary.

The skill isn't clinging to shell; it's knowing when to switch.

## Cross-reference

- [learn/06-advanced](../../../learn/06-advanced/en/notes.md) — parameter expansion (no-fork string ops).
- [learn/04-io-and-processes](../../../learn/04-io-and-processes/en/notes.md) — `xargs -P`, background jobs.
- [cheatsheets/parameter-expansion.md](../../../cheatsheets/parameter-expansion.md) — every string op you'd otherwise fork for.
