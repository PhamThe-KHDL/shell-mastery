# Solutions 12-dates-and-times

## 1.
The portable goal is clear output, even if the exact command differs between GNU and BSD `date`.

## 2.
Use a sortable timestamp format such as `%Y%m%d-%H%M%S`.

## 3.
Shell arithmetic with `(( b > a ))` is enough once both values are in epoch seconds.
