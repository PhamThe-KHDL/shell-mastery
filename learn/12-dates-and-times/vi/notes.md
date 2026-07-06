# 12-dates-and-times

## Mục tiêu
- Học các thao tác ngày giờ rất hay làm script vỡ khi đổi platform.
- Luyện tạo timestamp ổn định, parse input, và xử lý time zone cẩn thận.

## 1. Dùng format sortable

Với filename và log, hãy chọn format mà sort theo chữ cũng đúng thứ tự thời gian:

```sh
date -u +%Y%m%d-%H%M%S
date -u +%Y-%m-%dT%H:%M:%SZ
```

Những format này dễ xử lý hơn nhiều so với format phụ thuộc locale.

## 2. GNU vs BSD `date` là bẫy portability thật

macOS dùng BSD `date`; đa số Linux dùng GNU `date`.
Các flag format khá giống nhau, nhưng thao tác “N ngày trước” hay parse chuỗi thì khác đáng kể.

Điều đó nghĩa là:

- format đơn giản thường portable
- parse và date arithmetic thường không portable

Nếu bạn cần tính toán ngày giờ portable, hãy cô lập phần đó hoặc chuyển thành helper/library.

## 3. Epoch là format so sánh dễ nhất

Khi cần so sánh thời gian trong shell, epoch seconds đơn giản nhất:

```sh
if (( b > a )); then
    echo later
fi
```

Chuỗi dễ đọc dành cho log. Số epoch dành cho số học.

## 4. Ưu tiên UTC trong automation

Giờ địa phương dành cho con người. UTC dành cho hệ thống.

Scheduled job và log dễ debug hơn nhiều nếu dùng UTC:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Như vậy bạn tránh được DST surprise và câu hỏi “server này lúc đó ở timezone nào?”.

## Đọc thêm
- `topics/portability` vì xử lý ngày giờ là vùng rất nhạy platform.
- `lib/dates.sh` trong `ROADMAP.md`.
