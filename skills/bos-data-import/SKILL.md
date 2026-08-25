---
name: bos-data-import
description: >
  Làm sạch và nhập dữ liệu cho toàn nền tảng BOS (Business Operator System) — danh mục hàng hoá,
  tồn kho đầu kỳ, khách hàng/nhà cung cấp, công nợ đầu kỳ 4 chiều, đơn bán, đơn mua, chi phí,
  chấm công, số dư kế toán đầu kỳ, file đối soát sàn TMĐT. Gồm bản đồ cột chính xác của từng loại
  file, quy tắc định dạng số và ngày (khác nhau giữa các màn nhập), thứ tự nhập bắt buộc, cách chạy
  thử trước khi ghi sổ, và bảng lỗi → nguyên nhân → cách sửa. USE WHEN người dùng nói: import dữ liệu,
  nhập liệu BOS, làm sạch data, file import lỗi, nhập tồn đầu kỳ, nhập công nợ đầu kỳ, import sản phẩm,
  import khách hàng, đối soát sàn, chuẩn hoá file Excel cho BOS, chuyển dữ liệu từ Misa/Fast/KiotViet.
user-invocable: true
when_to_use: "Dùng khi xin dữ liệu của khách, khi nghiệm thu file khách vừa gửi (đủ/thiếu gì), khi làm sạch hoặc sửa lỗi file nhập vào BOS, và khi chuyển dữ liệu từ phần mềm cũ sang."
category: operations
keywords: [bos, import, lam-sach-du-lieu, ton-dau-ky, cong-no-dau-ky, excel, csv, doi-soat, migration]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# BOS · Làm sạch và nhập dữ liệu

Nhập sai dữ liệu đầu kỳ là lỗi đắt nhất khi lên hệ thống: sai tồn kho thì giá vốn sai theo mãi mãi,
sai công nợ thì đối soát với khách không bao giờ khớp. Skill này ghi lại **quy tắc thật của mã nguồn**,
không phải quy tắc đoán.

## Bắt đầu từ đâu

| Bạn đang ở tình huống nào | Đọc phần nào |
|---|---|
| Chưa xin dữ liệu của khách | [Xin dữ liệu và nghiệm thu](references/yeu-cau-va-nghiem-thu-du-lieu.md) — có mẫu tin nhắn gửi khách |
| Khách vừa gửi file, chưa biết đủ hay thiếu | Cùng file trên — quy trình nghiệm thu 15 phút |
| File đã nhận đủ, bắt đầu làm sạch | Tiếp tục đọc trang này |
| Cần biết cột nào bắt buộc | [Bản đồ cột](references/ban-do-cot.md) |
| Import đang báo lỗi | [Lỗi thường gặp](references/loi-thuong-gap.md) |

## Nguyên tắc số một: chạy thử trước, ghi sổ sau

Màn nào có nút **🔎 Chạy thử** thì bắt buộc chạy thử đến khi sạch lỗi mới bấm ghi. Import trong BOS
**không có nút hoàn tác**. Sai thì phải xoá tay từng chứng từ, hoặc restore backup.

Trước mọi lần import lớn: `deployments/bos-backup.sh <web_root>` (xem skill `bos-operations`).

## Thứ tự nhập bắt buộc

Nhập sai thứ tự là nguyên nhân số 1 khiến file "đúng" vẫn báo lỗi hàng loạt — vì đối tượng tham chiếu
chưa tồn tại.

```
1. Chi nhánh (Location)          ← tạo tay trước, tên phải chốt cuối cùng
2. Đơn vị tính · Thuế suất       ← import sản phẩm KHÔNG tự tạo hai thứ này
3. Nhóm hàng / Danh mục          ← có thể để import tự tạo
4. Sản phẩm (danh mục hàng hoá)
5. Tồn kho đầu kỳ                ← cần SKU đã có ở bước 4
6. Khách hàng / Nhà cung cấp
7. Công nợ đầu kỳ                ← cần đối tượng đã có ở bước 6
8. Số dư kế toán đầu kỳ (sổ cái) ← nhập riêng, KHÔNG thay cho bước 7
9. Đơn bán / đơn mua lịch sử     ← chỉ khi thật sự cần lịch sử
```

**Đơn vị tính và thuế suất không được tự tạo khi import sản phẩm** — thiếu là lỗi cả dòng
(`Unit with name X not found`). Tạo trước ở *Sản phẩm → Đơn vị tính* và *Cài đặt → Thuế suất*.

## Quy tắc làm sạch số (chỗ sai nhiều nhất)

BOS **không dùng chung một bộ đọc số** cho mọi màn nhập. Phải biết màn nào dùng bộ nào:

| Màn nhập | Cách đọc số | Nghĩa là file phải viết số thế nào |
|---|---|---|
| Tồn kho đầu kỳ | `is_numeric()` thuần | **Chỉ chữ số và dấu chấm thập phân**: `1500000` hoặc `1500000.5`. `1.500.000` hay `1,500,000` đều **báo lỗi** |
| Sản phẩm, đơn bán, đơn mua, chi phí | `num_uf()` — theo cài đặt tiền tệ của doanh nghiệp | Phải đúng dấu ngăn nghìn/thập phân **đang cấu hình trong hệ thống**, không phải theo thói quen người gõ |
| File đối soát sàn TMĐT | bộ đọc thông minh (tự nhận dạng) | Chấp nhận cả `1.234,56` và `1,234.56`; `(1.234)` = số âm kiểu kế toán |

**Bẫy quan trọng nhất:** bộ đọc thông minh coi *đúng 3 chữ số sau dấu phân cách* là **ngăn nghìn**.
Nên `1.500` được hiểu là **1500**, không phải 1,5. Nếu dữ liệu thật là 1,5 đơn vị thì phải ghi `1.50`
hoặc `1,50` — thêm/bớt một chữ số để thoát khỏi quy tắc 3 số.

**Checklist làm sạch số trước khi nộp file:**
- Bỏ toàn bộ ký tự tiền tệ: `đ`, `VND`, `₫`, khoảng trắng cứng (non-breaking space từ Excel).
- Bỏ dấu ngăn nghìn nếu nộp vào màn Tồn kho đầu kỳ.
- Số âm: dùng dấu `-` phía trước. Chỉ file đối soát sàn mới hiểu `(1.234)`.
- Ô trống ≠ số 0: cột bắt buộc mà để trống là lỗi, đừng điền `-` hay `N/A`.
- Cẩn thận Excel tự đổi số dài thành `1.5E+10` — format cột thành Text trước khi lưu CSV.

## Quy tắc làm sạch ngày

Không có một định dạng ngày duy nhất cho cả hệ thống — đây là chuyện thật của mã nguồn:

| Màn nhập | Định dạng ngày bắt buộc |
|---|---|
| **Sản phẩm** → cột EXPIRY DATE | `m-d-Y` (**tháng trước, kiểu Mỹ**) — vd `12-31-2026` |
| **Tồn kho đầu kỳ** → cột EXPIRY DATE | Theo **định dạng ngày cài trong doanh nghiệp** (thường `d-m-Y`) |
| Đơn bán / đơn mua / chi phí | Theo định dạng ngày cài trong doanh nghiệp |

→ Cùng một khái niệm "hạn sử dụng" nhưng hai màn đòi hai kiểu. Trước khi import hãy mở
*Cài đặt → Doanh nghiệp → Định dạng ngày* xem hệ thống đang để gì, rồi mới chuẩn hoá file.

Ngày sai định dạng thường **không báo lỗi tử tế** mà làm chết cả lần import — nên tách riêng
vài dòng có ngày ra nhập thử trước.

## Quy tắc làm sạch chữ

- **Tên chi nhánh phải trùng khớp tuyệt đối** với tên trong hệ thống — kể cả dấu tiếng Việt,
  hoa/thường, khoảng trắng thừa. Sai là lỗi cả dòng.
- Doanh nghiệp có **nhiều chi nhánh** thì cột chi nhánh là **bắt buộc**, không được để trống.
- Khoảng trắng đầu/cuối được tự cắt, nhưng khoảng trắng đôi ở giữa thì không — dùng
  `TRIM()` + tìm-thay `"  "` → `" "` trong Excel.
- Xoá dòng trống ở cuối file: Excel hay lưu kèm vài trăm dòng rỗng thành CSV.
- Lưu CSV bằng **UTF-8**. Lưu bằng Excel mặc định trên Windows dễ ra ANSI → hỏng hết dấu tiếng Việt.
- Cột SKU để trống thì hệ thống **tự sinh mã**. Muốn khớp với phần mềm cũ thì phải điền tay.

## Cụ thể từng loại file

Bản đồ cột đầy đủ, từng cột bắt buộc/tuỳ chọn, và mẫu tải sẵn: xem
[references/ban-do-cot.md](references/ban-do-cot.md).

Mẫu file tải trong hệ thống nằm ở `public/files/` — luôn tải mẫu mới từ chính màn hình đang dùng,
đừng dùng lại mẫu cũ đã lưu trên máy (số cột có thể đã đổi, sai số cột là lỗi
`Some of the columns are missing`).

## Công nợ đầu kỳ — có 4 chiều, không phải 2

Đây là nghiệp vụ hay bị làm sai nhất. Công nợ luôn có hai chiều, và mỗi chiều có hai trạng thái:

| Thực tế | Kế toán ghi | Nhập BOS loại | Vào đâu trong hệ thống |
|---|---|---|---|
| Khách **còn nợ** mình | TK 131 dư Nợ | `1` | Nợ đầu kỳ — báo cáo công nợ phải thu |
| Khách **trả trước** cho mình | TK 131 dư Có | `3` | **Tạm ứng của khách** — cấn trừ khi bán |
| Mình **còn nợ** nhà cung cấp | TK 331 dư Có | `2` | Nợ đầu kỳ — công nợ phải trả |
| Mình **trả trước** cho NCC | TK 331 dư Nợ | `4` | **Tiền đã ứng cho NCC** — cấn trừ khi nhập hàng |

Điểm mấu chốt: **khoản trả trước không phải là nợ** — ghi nhầm vào nợ đầu kỳ sẽ làm sai cả hai
báo cáo công nợ.

Cách nhập: *Khách hàng → Tải lên công nợ đầu kỳ* (`/contacts/import-debts`). Nhận thẳng file
"Tổng hợp công nợ phải thu/phải trả" xuất từ Fast/Misa — hệ thống tự nhận bảng có **Số dư cuối kỳ
(Nợ/Có)** và tự suy chiều theo cột TK 131/331. Số dư *cuối kỳ năm cũ* chính là số dư *đầu kỳ năm mới*.

Chốt chặn có sẵn trong hệ thống:
- Mỗi đối tượng chỉ nhận **nợ đầu kỳ một lần** — lần 2 bị bỏ qua kèm cảnh báo, tránh nhân đôi công nợ.
  Riêng *tạm ứng* không chặn vì thực tế ứng nhiều lần.
- Đối tượng có nợ ở **cả 131 và 331** sẽ được **tách hồ sơ riêng**, cố ý không bù trừ hai tài khoản.
- Tài khoản không phải 131/331 bị bỏ qua kèm báo dòng.

**Trước khi nhập công nợ phải import xong danh sách khách/NCC.** Kinh nghiệm thật: một khách có
420 đối tượng trong sổ kế toán nhưng hệ thống mới có 35 — chạy thử báo 59 đối tượng chưa khớp,
phải quay lại bước 6.

Số tổng 131/331 trên **sổ cái** nhập riêng ở *Kế toán → Nhập số dư đầu kỳ*. Màn công nợ là sổ
**chi tiết theo từng đối tượng** — hai màn khác nhau, phải nhập cả hai và số tổng phải khớp nhau.

## Khi import báo lỗi

Bảng lỗi → nguyên nhân → cách sửa: [references/loi-thuong-gap.md](references/loi-thuong-gap.md).

Nguyên tắc đọc lỗi: hệ thống báo **theo số dòng của file** (kể cả dòng tiêu đề). Mở file, nhảy đúng
dòng đó, sửa, rồi chạy thử lại **cả file** — đừng chỉ nhập lại phần đã sửa, vì các dòng trước đó có
thể đã ghi vào hệ thống.

Màn tồn kho đầu kỳ chỉ hiển thị **tối đa 50 lỗi** một lần dù có nhiều hơn — sửa hết 50 rồi chạy lại
để lộ tiếp phần còn lại.

## Chuyển từ phần mềm cũ (Misa, Fast, KiotViet, Sapo)

1. Xuất từ phần mềm cũ ở dạng Excel/CSV, **không** dùng file PDF hay bản in.
2. Chốt **khoá khớp đối tượng**: mã khách hàng nội bộ hay mã số thuế? Chọn **một** và dùng thống nhất.
   File thực tế hay lẫn cả hai (dòng thì MST `0309810578`, dòng thì mã nội bộ `BH-15C38947`) — phải
   thống nhất trước khi nhập, không thì khớp sai đối tượng.
3. Ánh xạ cột file cũ → cột mẫu BOS bằng file trung gian, giữ lại file gốc không sửa để đối chiếu.
4. Nhập theo đúng thứ tự ở trên, mỗi bước chạy thử trước.
5. Sau khi ghi sổ: đối chiếu **tổng tiền** và **số lượng dòng** giữa file gốc và báo cáo BOS.
   Lệch một đồng cũng phải tìm ra, đừng bỏ qua.

## Việc phải làm sau khi import xong

- Đối chiếu tổng: tồn kho (số lượng × giá vốn), công nợ phải thu, công nợ phải trả, số dư sổ cái.
- Kiểm tra vài sản phẩm bất kỳ: giá vốn, giá bán, tồn theo từng chi nhánh.
- Nếu có nhiều chi nhánh: kiểm tra tồn không bị dồn hết về một chi nhánh (dấu hiệu cột chi nhánh trống).
- Ghi lại vào nhật ký vận hành: ngày nhập, file nào, ai nhập, số dòng, tổng tiền. Cần khi đối chiếu sau này.
