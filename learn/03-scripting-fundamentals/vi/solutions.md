# Lời giải 03 · Nền tảng scripting

## 1.
```sh
for i in {1..30}; do
    if   (( i % 15 == 0 )); then echo FizzBuzz
    elif (( i % 3  == 0 )); then echo Fizz
    elif (( i % 5  == 0 )); then echo Buzz
    else echo "$i"
    fi
done
```

## 2.
```sh
greet() { local name=${1:-world}; echo "hello, $name"; }
greet          # hello, world
greet alice    # hello, alice
```

## 3.
```sh
usage() { echo "Usage: $0 -n NAME [-c COUNT]" >&2; exit 2; }
name=""; count=1
while getopts ":n:c:" opt; do
    case $opt in
        n) name=$OPTARG ;;
        c) count=$OPTARG ;;
        *) usage ;;
    esac
done
[[ -n $name ]] || usage
for ((i=0; i<count; i++)); do echo "hello, $name"; done
```

## 4.
```sh
retry() {
    local max=$1; shift
    local attempt=1 delay=1
    local status
    while (( attempt <= max )); do
        if "$@"; then
            return 0
        fi
        status=$?
        (( attempt == max )) && return "$status"
        sleep "$delay"
        delay=$(( delay * 2 ))
        attempt=$(( attempt + 1 ))
    done
}
```

## 5.
`cmd3` chạy khi `cmd1` HOẶC `cmd2` fail — vì `&&` short-circuit rồi `||` bắt fail đó. If/then/else thật sự chỉ chạy `cmd3` khi `cmd1` fail, không liên quan đến kết quả `cmd2`.
