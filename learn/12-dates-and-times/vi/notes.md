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

Tránh các format kiểu `07/06/26 2:30 PM` trong automation. Chúng vừa mơ hồ với con người, vừa khó chịu cho script.

## 2. GNU vs BSD `date` là bẫy portability thật

macOS dùng BSD `date`; đa số Linux dùng GNU `date`.
Các flag format khá giống nhau, nhưng thao tác “N ngày trước” hay parse chuỗi thì khác đáng kể.

Điều đó nghĩa là:

- format đơn giản thường portable
- parse và date arithmetic thường không portable

Nếu bạn cần tính toán ngày giờ portable, hãy cô lập phần đó hoặc chuyển thành helper/library.

Phần format thường vẫn ổn:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Nhưng phần relative arithmetic mới là nơi khác biệt:

```sh
date -d 'yesterday'              # GNU
date -v-1d                      # BSD/macOS
```

Chỉ riêng khác biệt này cũng đủ khiến nhiều repo shell tránh date math trực tiếp hoặc phải bọc nó sau một helper function.

## 3. Epoch là format so sánh dễ nhất

Khi cần so sánh thời gian trong shell, epoch seconds đơn giản nhất:

```sh
a=$(date +%s)
b=$((a + 60))

if (( b > a )); then
    echo later
fi
```

Chuỗi dễ đọc dành cho log. Số epoch dành cho số học.

Điều này cũng đúng với age checks:

```sh
now=$(date +%s)
cutoff=$((now - 3600))
```

Khi mọi thứ đã là số, shell arithmetic thông thường là đủ.

## 4. Ưu tiên UTC trong automation

Giờ địa phương dành cho con người. UTC dành cho hệ thống.

Scheduled job và log dễ debug hơn nhiều nếu dùng UTC:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Như vậy bạn tránh được DST surprise và câu hỏi “server này lúc đó ở timezone nào?”.

Nếu con người cần giờ địa phương, hãy chỉ convert một lần ở đúng ranh giới nơi bạn hiển thị hoặc gửi email kết quả.

## 5. Filename và log cần hai kiểu timestamp khác nhau

Cho filename:

```sh
stamp=$(date -u +%Y%m%d-%H%M%S)
out="backup-${stamp}.tar.gz"
```

Cho log:

```sh
date -u +%Y-%m-%dT%H:%M:%SZ
```

Cả hai đều sort được. Dạng filename tránh dấu `:` và khoảng trắng; dạng log dễ đọc hơn cho con người và cho các tool bên ngoài vốn mong đợi ISO 8601.

## 6. Parse input một lần rồi chuẩn hóa

Nếu script nhận timestamp do người dùng cung cấp, hãy chuyển nó ngay về dạng mà bạn sẽ đem đi so sánh:

- epoch nếu cần tính toán
- UTC ISO 8601 nếu cần format trao đổi ổn định

Đừng cứ qua lại giữa nhiều layout thời gian khác nhau trừ khi bạn muốn tự làm khó mình với bug timezone.

## Đọc thêm
- `topics/portability` vì xử lý ngày giờ là vùng rất nhạy platform.
- `lib/dates.sh` trong `ROADMAP.md`.
