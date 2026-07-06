# Lời giải 14-testing-shell

## 1.
Dùng `load '../lib/foo.sh'` và assertion shell thông thường để test function trực tiếp.

## 2.
`run "$SCRIPT"` rồi kiểm tra `$status` thay vì để test abort quá sớm.

## 3.
`mktemp -d` cùng `teardown()` là mặc định sạch nhất cho filesystem tests.
