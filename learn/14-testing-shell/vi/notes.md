# 14-testing-shell

## Mục tiêu
- Biến việc test shell từ “biết Bats tồn tại” thành workflow lặp lại được.
- Học cách test function, script, lỗi, và filesystem effect mà không đoán mò.

## 1. Bats thực chất là gì

Bats chỉ là bash cộng thêm test runner.

Mỗi khối `@test` là một bash function:

```bash
@test "trim: removes outer whitespace" {
    result=$(trim "  hello  ")
    [ "$result" = "hello" ]
}
```

Nếu một command exit khác 0 thì test fail, trừ khi bạn bọc nó trong `run`.

## 2. `run` là helper quan trọng nhất

Dùng `run` khi command có thể fail và bạn muốn kiểm tra failure:

```bash
run "$SCRIPT" --bad-flag
[ "$status" -eq 2 ]
[[ "$output" == *"Usage:"* ]]
```

Nếu không có `run`, exit code khác 0 sẽ làm test abort ngay.

## 3. Test library khác test script

Hai kiểu này nên test khác nhau:

- `lib/*.sh` → `load` file rồi gọi function trực tiếp
- `projects/*.sh` → chạy script như subprocess

Cách test nên phản ánh cách caller thật sự dùng code.

## 4. Filesystem test cần tempdir

Mặc định sạch nhất là:

```bash
setup() {
    tmp=$(mktemp -d)
}

teardown() {
    rm -rf "$tmp"
}
```

Tránh để nhiều test dùng chung filesystem state nếu không có lý do rất rõ ràng.

## 5. Nên cover những gì

Một shell test suite tối thiểu hữu ích nên có:

1. một happy path
2. một invalid-input path
3. một edge case

Với script CLI, điều đó thường nghĩa là:

- thiếu required flags
- một run thành công
- một failure như input không đọc được hoặc config sai

## 6. Khi nào nên dừng test bằng shell

Shell + Bats rất hợp cho hành vi CLI, exit code, và filesystem effect nhẹ.
Nó bắt đầu khó chịu khi bạn cần:

- sinh fixture phức tạp
- assert JSON phức tạp
- orchestration nhiều process
- mocking giàu tính năng

Đến lúc đó, Python `pytest` + `subprocess` thường là công cụ tốt hơn.

## Đọc thêm
- `tests/README.md` — phần tài liệu đi kèm trong repo, cho bạn xem lesson này được áp dụng vào test suite thật như thế nào.
- Các file test trong `projects/` như worked example có thể đọc ngay.
