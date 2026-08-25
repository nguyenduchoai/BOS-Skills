# Bài tập nghiệm thu dữ liệu

Bốn file trong thư mục này là **một bộ dữ liệu khách gửi tới**, có lỗi cài sẵn. Dùng cho bài kiểm
tra cuối tuần 2 trong lộ trình `bos-nhan-vien-moi`.

## Đề bài

Một khách hàng mới — garage ô tô, có **một chi nhánh tên "Kho Hà Nội"** — vừa gửi 4 file:

| File | Nội dung |
|---|---|
| `01-danh-muc-hang-hoa.csv` | Danh mục hàng hoá |
| `02-ton-dau-ky.csv` | Tồn kho đầu kỳ |
| `03-khach-hang.csv` | Khách hàng và nhà cung cấp |
| `04-cong-no.csv` | Công nợ đầu kỳ |

Trong hệ thống hiện đã có sẵn: chi nhánh **Kho Hà Nội**, các đơn vị tính **Cái · Chai · Bộ · Can**,
và thuế suất **VAT 10%**.

### Việc phải làm

Chạy quy trình nghiệm thu 15 phút trong skill `bos-data-import`
(`references/yeu-cau-va-nghiem-thu-du-lieu.md`), rồi nộp:

1. **Kết luận**: nhận đủ / nhận được nhưng thiếu phụ / trả lại xin bổ sung
2. **Danh sách lỗi** — ghi rõ **file nào, dòng nào, lỗi gì**
3. **Thư gửi khách** — nói cụ thể thiếu gì, kèm danh sách chi tiết, không nói chung chung

### Chấm đạt khi

- Tìm được **ít nhất 80%** số lỗi cài sẵn
- **Bắt được cả 3 lỗi bắt buộc** (xem `DAP-AN.md`) — đây là ba lỗi tốn tiền nhất, sót một cái là chưa đạt
- Thư gửi khách **có danh sách cụ thể**, không bắt khách tự đi tìm

## Lưu ý cho người kèm

- Đưa 4 file, **không** đưa `DAP-AN.md`.
- Cho làm trong 30 phút. Quá giờ mà chưa xong cũng là dữ liệu đánh giá.
- Sau khi chấm: hỏi *"lúc đó bạn nghĩ gì"* với từng lỗi bị sót, trước khi chỉ ra chỗ sai — để biết
  lỗ hổng nằm ở hiểu biết nào, không phải ở sự cẩu thả.
