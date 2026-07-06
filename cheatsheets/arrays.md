# Cheatsheet · Arrays (bash 4+)

## Indexed arrays

```sh
arr=(a b c "d e")             # create
arr[5]=x                      # sparse assign
arr+=(y z)                    # append
echo "${arr[0]}"              # element
echo "${arr[@]}"              # all elements (each = one arg)
echo "${arr[*]}"              # all elements joined by $IFS[0] (usually space)
echo "${#arr[@]}"             # count
echo "${!arr[@]}"             # indices (useful for sparse arrays)

# Slice
echo "${arr[@]:1:3}"          # 3 elements starting at index 1
echo "${arr[@]: -2}"          # last 2 elements (note space before -)

# Iterate
for x in "${arr[@]}"; do echo "$x"; done
for i in "${!arr[@]}"; do echo "$i → ${arr[$i]}"; done

# Delete
unset 'arr[2]'                # leaves a gap in indices
arr=("${arr[@]}")             # re-pack

# Read a file into an array
mapfile -t lines < file.txt
readarray -t lines < file.txt          # same thing
mapfile -t hosts < <(cut -d, -f1 hosts.csv)   # from a command
```

## Associative arrays

```sh
declare -A user
user[name]=alice
user[email]=alice@x.com

echo "${user[name]}"
echo "${!user[@]}"            # keys
echo "${user[@]}"             # values
echo "${#user[@]}"            # count
[[ -v user[name] ]]           # key exists?
unset 'user[name]'

# Iterate
for k in "${!user[@]}"; do
    printf '%s=%s\n' "$k" "${user[$k]}"
done
```

## Pitfalls

- Unquoted `${arr[@]}` word-splits and glob-expands. **Always** `"${arr[@]}"`.
- `${arr[*]}` joins into one string — different from `"${arr[@]}"`. Use `*` when you deliberately want joining.
- `arr[0]` and `$arr` refer to the same element in bash — but the second is confusing; use `${arr[0]}`.
