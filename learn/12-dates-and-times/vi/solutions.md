# Lời giải 12-dates-and-times

## 1.
Mục tiêu là output portable, dù command cụ thể có thể khác giữa GNU và BSD `date`.

## 2.
Dùng format timestamp sortable như `%Y%m%d-%H%M%S`.

## 3.
Toán tử số học shell `(( b > a ))` là đủ khi cả hai giá trị đã ở dạng epoch seconds.
