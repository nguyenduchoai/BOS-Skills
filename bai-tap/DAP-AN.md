# Đáp án — 14 lỗi cài sẵn

> **Chỉ dành cho người kèm.** Không đưa file này cho người học.

## Ba lỗi BẮT BUỘC phải bắt được

Sót một trong ba lỗi này là chưa đạt, dù tìm được các lỗi khác.

| # | File · dòng | Lỗi | Vì sao tốn tiền |
|---|---|---|---|
| **1** | `02-ton-dau-ky` dòng 5 | Chi nhánh ghi **"Chi nhánh Hà Nội"**, các dòng khác ghi **"Kho Hà Nội"** | Tên chi nhánh phải trùng khớp tuyệt đối. Một chữ khác là dòng đó hỏng, và nếu không phát hiện thì tồn kho lệch mà không ai biết nguyên nhân |
| **2** | `02-ton-dau-ky` dòng 11, 13 | Mã **PHA-002** và **LOP-003** không có trong danh mục hàng hoá | Nhập tồn cho hàng chưa tồn tại là lỗi cả dòng. Phải kiểm chéo hai file, không chỉ kiểm từng file |
| **3** | `02-ton-dau-ky` dòng 10 | Số lượng ghi **1.500** — là 1500 cái hay 1,5 cái? | Hệ thống hiểu là 1500 (quy tắc 3 chữ số). Nếu khách muốn 1,5 thì lệch 1000 lần. Phải hỏi lại khách, không được tự đoán |

## Các lỗi còn lại

### File 01 — Danh mục hàng hoá

| Dòng | Lỗi | Cách xử lý |
|---|---|---|
| 4 | Đơn vị tính **"Thùng"** chưa có trong hệ thống | Import không tự tạo đơn vị tính — tạo trước, hoặc đổi sang đơn vị đã có |
| 6 | Cột quản lý tồn kho ghi **"Có"** thay vì `1` | Sửa thành `1` |
| 8 | Loại hàng ghi **"đơn"** thay vì `single` | Sửa thành `single` |
| 10 | Mã **LOP-001 bị trùng** với dòng 2 (Lốp Michelin) — dòng 10 là Lọc dầu | Hỏi khách mã đúng của Lọc dầu là gì. Không tự đặt mã mới |
| 12 | Má phanh **thiếu cả hai cột giá vốn** | Phải có ít nhất một trong hai. Hỏi khách |

### File 02 — Tồn đầu kỳ

| Dòng | Lỗi | Cách xử lý |
|---|---|---|
| 7 | Giá vốn ghi **1.620.000** | Hệ thống đọc được thành 1620000 — **không phải lỗi** sau bản cập nhật. Người học nêu ra là tốt, nhưng đừng bắt khách sửa |
| 11 | Má phanh **PHA-002 thiếu giá vốn** | Cột bắt buộc. Trùng với lỗi thiếu giá ở file 01 — cùng một mặt hàng |
| 12 | Hạn sử dụng **45/13/2027** — ngày và tháng đều không tồn tại | Hỏi khách ngày đúng |

### File 03 — Khách hàng / NCC

| Dòng | Lỗi | Cách xử lý |
|---|---|---|
| 8 | **Trùng khách**: "Trần Văn Bình" xuất hiện ở dòng 2 (KH-001) và dòng 8 (KH-005), cùng mã số thuế và cùng số điện thoại | Hai mã cho một pháp nhân. Hỏi khách giữ mã nào — nếu nhập cả hai thì công nợ bị chia đôi |
| — | Toàn bộ file **thiếu cột email** (có tiêu đề nhưng không dòng nào điền) | Không chặn được việc nhập, nhưng sau này không gửi được thông báo. Nêu trong thư gửi khách |

### File 04 — Công nợ

| Dòng | Lỗi | Cách xử lý |
|---|---|---|
| 7 | **Số tiền âm** (-58.700.000) cho NCC-002 | Chiều nợ đã nằm ở cột Loại — số tiền luôn dương. Hỏi khách ý định thật: nợ NCC hay NCC nợ mình |
| 9 | **KH-009 không có** trong file khách hàng | Đối tượng chưa tồn tại thì không ghi nợ được. Xin bổ sung |
| 10 | **"Vũ Thị Lan"** không có trong file khách hàng | Như trên |
| 11 | Cột Loại ghi **5** — chỉ có 1, 2, 3, 4 | Hỏi khách đây là chiều nào |

## Kết luận đúng

> **Trả lại xin bổ sung.**

Lý do: thiếu dữ liệu bắt buộc (giá vốn của má phanh), có hàng trong file tồn mà không có trong danh
mục, có đối tượng công nợ chưa tồn tại, và có mấy chỗ **phải hỏi khách mới biết ý định thật**
(số lượng 1.500, số tiền âm, mã trùng).

Không được tự đoán và nhập bừa. Ba chỗ cần hỏi khách kia mà đoán sai thì sai số liệu ngay từ ngày đầu.

## Thang điểm gợi ý

| Số lỗi tìm được | Đánh giá |
|---|---|
| Đủ 3 lỗi bắt buộc + ≥ 11/14 lỗi | Đạt tốt — cho nhận file khách thật có người soát |
| Đủ 3 lỗi bắt buộc + 8–10 lỗi | Đạt — làm thêm một bộ nữa |
| Sót lỗi bắt buộc, hoặc < 8 lỗi | Chưa đạt — học lại phần nghiệm thu, làm lại tuần sau |

Điểm cộng khi người học **tự nhận ra phải kiểm chéo giữa các file** mà không cần nhắc — đó là dấu
hiệu đã hiểu bản chất chứ không làm theo danh sách.
