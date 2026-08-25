# Bản đồ cột từng loại file import

> Số cột và thứ tự cột là **cố định theo vị trí**, không theo tên tiêu đề. Thêm/bớt/đảo cột là hỏng.
> Luôn tải mẫu mới ngay trên màn hình đang dùng (`public/files/`), đừng dùng mẫu cũ lưu trên máy.

## 1. Sản phẩm — 35 cột

Mẫu: `public/files/import_products_csv_template.csv`

| # | Cột | Bắt buộc | Ghi chú |
|---|---|---|---|
| 1 | NAME | Có¹ | ¹Có thể để trống nếu điền Hiệu + Size + Mã để hệ thống tự ghép tên |
| 2 | BRAND | Không | Chưa có thì **tự tạo mới** |
| 3 | UNIT | **Có** | **Phải tồn tại sẵn** — không tự tạo |
| 4 | CATEGORY | Không | Chưa có thì tự tạo |
| 5 | SUB-CATEGORY | Không | Chưa có thì tự tạo, nằm dưới CATEGORY |
| 6 | SKU | Không | Để trống → hệ thống tự sinh mã |
| 7 | BARCODE TYPE | Không | Chỉ nhận các loại hợp lệ (C128, C39, EAN-13, EAN-8, UPC-A, UPC-E) |
| 8 | MANAGE STOCK | **Có** | `1` = quản lý tồn, `0` = không. Giá trị khác → lỗi |
| 9 | ALERT QUANTITY | Không | Ngưỡng cảnh báo sắp hết hàng |
| 10 | EXPIRES IN | Không | Số kỳ hạn sử dụng |
| 11 | EXPIRY PERIOD UNIT | Không | `months` hoặc `days` |
| 12 | APPLICABLE TAX | Không | **Phải tồn tại sẵn** trong Cài đặt → Thuế suất |
| 13 | Selling Price Tax Type | **Có** | `inclusive` (đã gồm thuế) hoặc `exclusive` |
| 14 | PRODUCT TYPE | **Có** | `single` hoặc `variable` |
| 15 | VARIATION NAME | Có nếu `variable` | Vd: "Màu sắc" |
| 16 | VARIATION VALUES | Có nếu `variable` | Ngăn bằng dấu `\|`: `Đỏ\|Xanh\|Vàng` |
| 17 | PURCHASE PRICE (gồm thuế) | Có² | ²Phải có ít nhất một trong cột 17 hoặc 18 |
| 18 | PURCHASE PRICE (chưa thuế) | Có² | |
| 19 | PROFIT MARGIN | Không | % lãi, dùng để tự tính giá bán |
| 20 | SELLING PRICE | Không | Trống → tính từ giá vốn + margin |
| 21 | OPENING STOCK | Không | Hàng `variable` thì ngăn bằng `\|` theo đúng thứ tự VARIATION VALUES |
| 22 | LOCATION | **Có nếu nhiều chi nhánh** | Tên phải **trùng khớp tuyệt đối** |
| 23 | EXPIRY DATE | Không | ⚠️ Định dạng **`m-d-Y`** (tháng trước, kiểu Mỹ): `12-31-2026` |
| 24 | ENABLE IMEI OR SERIAL | Không | `1` / `0` |
| 25 | WEIGHT | Không | |
| 26–28 | RACK, ROW, POSITION | Không | Vị trí trên kệ |
| 29 | IMAGE | Không | Tên file trong thư mục ảnh, hoặc URL (bị chặn SSRF nếu URL nội bộ) |
| 30 | PRODUCT DESCRIPTION | Không | |
| 31–34 | CUSTOM FIELD 1–4 | Không | |
| 35 | NOT FOR SELLING | Không | `1` = không bán (hàng nguyên vật liệu) |

## 2. Tồn kho đầu kỳ — 6 cột

Mẫu: `public/files/import_opening_stock_csv_template.csv`

| # | Cột | Bắt buộc | Quy tắc |
|---|---|---|---|
| 1 | PRODUCT SKU | **Có** | Phải là SKU **đã tồn tại**; sản phẩm phải **đã bật Quản lý tồn kho** |
| 2 | LOCATION NAME | **Có nếu nhiều chi nhánh** | Trùng khớp tuyệt đối |
| 3 | QUANTITY | **Có** | ⚠️ **Số thuần**, không dấu ngăn nghìn |
| 4 | UNIT COST (BEFORE TAX) | **Có** | ⚠️ **Số thuần**. Là giá vốn **chưa thuế** |
| 5 | LOT NUMBER | Không | Số lô |
| 6 | EXPIRY DATE | Không | Theo **định dạng ngày cài trong doanh nghiệp** (khác màn Sản phẩm!) |

Chốt chặn: sản phẩm đã có tồn đầu kỳ tại chi nhánh đó rồi thì lần nhập sau **không cộng dồn** — hệ
thống nhận diện chứng từ `opening_stock` đã tồn tại. Muốn sửa số thì sửa trên chứng từ tồn đầu kỳ.

## 3. Khách hàng / Nhà cung cấp — 21 cột

Mẫu: `public/files/import_contacts_csv_template.csv`

`CONTACT TYPE` · `NAME` · `BUSINESS NAME` · `CONTACT ID` · `TAX NUMBER` · `OPENING BALANCE` ·
`PAY TERM` · `PAY TERM PERIOD` · `CREDIT LIMIT` · `EMAIL` · `MOBILE` · `ALT. CONTACT NO.` ·
`LANDLINE` · `CITY` · `STATE` · `COUNTRY` · `LANDMARK` · `CUSTOM FIELD 1–4`

- `CONTACT TYPE`: khách hàng / nhà cung cấp / cả hai.
- `CONTACT ID` là **khoá khớp** khi nhập công nợ sau này — điền đúng mã dùng trong sổ kế toán cũ.
- `OPENING BALANCE` ở đây chỉ là số dư đơn giản một chiều. Cần đủ 4 chiều thì dùng màn
  **Tải lên công nợ đầu kỳ** thay vì cột này.

## 4. Công nợ đầu kỳ 4 chiều

Màn: *Khách hàng → Tải lên công nợ đầu kỳ* (`/contacts/import-debts`). Nhận `xlsx`, `xls`, `csv`, tối đa 10MB.

**Cách 1 (khuyên dùng)** — nộp thẳng file *Tổng hợp công nợ phải thu/phải trả* xuất từ Fast/Misa.
Hệ thống tự tìm bảng có cột **Số dư cuối kỳ (Nợ/Có)** và tự suy chiều theo TK 131/331.

**Cách 2** — mẫu rút gọn 4 cột:

| Cột | Nội dung |
|---|---|
| Loại | `1` khách nợ mình · `2` mình nợ NCC · `3` khách trả trước · `4` mình ứng cho NCC |
| Tên / SĐT / Mã / MST | Khoá khớp đối tượng — phải **đã tồn tại** trong hệ thống |
| Số tiền | Phải **lớn hơn 0** (chiều đã nằm ở cột Loại, không dùng số âm) |
| Ghi chú | Tuỳ chọn |

## 5. Đơn bán (import lịch sử)

Mẫu: `public/files/import_sales_template.xlsx`

Bắt buộc: **hoặc** `customer_phone_number` **hoặc** `customer_email` (một trong hai);
**hoặc** `product` **hoặc** `sku` (một trong hai); `quantity` bắt buộc.

Chỉ import đơn lịch sử khi thật sự cần — đơn bán sẽ **trừ tồn kho**, nhập sau khi đã nhập tồn đầu kỳ
sẽ làm tồn âm nếu kỳ tồn đầu không bao trùm.

## 6. Đơn mua

Mẫu: `public/files/import_purchase_products_template.xls`. Xử lý qua `PurchaseImportService`.

## 7. Chi phí

Mẫu: `public/files/import_expense_csv_template.csv`. Chỉ 3 cột bắt buộc: `LOCATION`, `TOTAL AMOUNT`,
`PAYMENT METHOD` — phần còn lại tuỳ chọn. `EXPENSE FOR` khớp theo email/username của nhân viên.

## 8. Chấm công

Mẫu: `public/modules/essentials/files/import_attendance_template.xls`. Màn: *Nhân sự → Chấm công → Nhập từ file*.

## 9. Số dư kế toán đầu kỳ (sổ cái)

Màn: *Kế toán → Nhập số dư đầu kỳ* (`VnOpeningImportController`). Đây là số **tổng theo tài khoản**,
độc lập với công nợ chi tiết theo đối tượng. Phải nhập **cả hai** và số tổng TK 131/331 giữa hai màn
phải khớp nhau.

## 10. Tài sản cố định / CCDC đầu kỳ

Màn: *Sổ tài sản → Nhập tài sản đầu kỳ* (`AstOpeningImportController`).

## 11. File đối soát sàn TMĐT (Shopee/TikTok/Lazada)

Module `MarketplaceSync`. Đây là loại file **duy nhất** có bộ đọc số thông minh:
- Nhận cả `1.234,56` và `1,234.56`.
- `(1.234)` = **số âm** kiểu kế toán.
- Tự bỏ ký tự tiền tệ.
- ⚠️ Đúng 3 chữ số sau dấu phân cách → hiểu là **ngăn nghìn** (`1.500` = 1500).

Tên cột phí được khớp tự động sau khi bỏ dấu tiếng Việt và chuẩn hoá. Cột phí lạ không nhận diện
được vẫn **giữ lại** dưới mã `unknown:<tên cột>` chứ không bị bỏ im lặng — kiểm tra danh sách
`unknown` sau mỗi lần nhập để bổ sung ánh xạ.

Dòng phí **lệch dấu** so với nhóm là khoản sàn **hoàn lại** (clawback ngược) — hệ thống xử lý riêng
để tổng phí không bị phồng gấp đôi. Đừng "sửa" dấu âm trong file đối soát cho "đẹp".
