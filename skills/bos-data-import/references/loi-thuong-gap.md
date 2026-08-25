# Lỗi import: thông báo → nguyên nhân → cách sửa

> Thông báo lỗi bên dưới là chuỗi thật trong mã nguồn BOS. Tìm theo từ khoá trong thông báo bạn nhận được.

## Lỗi cấu trúc file

| Thông báo | Nguyên nhân | Cách sửa |
|---|---|---|
| `Some of the columns are missing. Please, use latest CSV file template.` | File thiếu cột, hoặc dùng mẫu cũ đã đổi số cột | Tải lại mẫu **ngay trên màn hình đang dùng**, dán dữ liệu sang mẫu mới |
| `Please install/enable PHP Zip archive for import` | Server thiếu extension `zip` của PHP | Việc của kỹ thuật: bật `php-zip` rồi khởi động lại PHP-FPM |
| Import chạy xong mà không có dòng nào vào | File CSV lưu sai mã hoá, hoặc toàn dòng trống ở cuối | Lưu lại bằng **UTF-8**, xoá dòng trống cuối file |
| Chữ tiếng Việt thành `?` hoặc ký tự lạ | File lưu ANSI thay vì UTF-8 | Excel → Save As → **CSV UTF-8** |

## Lỗi danh mục chưa tồn tại

| Thông báo | Nguyên nhân | Cách sửa |
|---|---|---|
| `Unit with name X not found in row no. N` | Đơn vị tính chưa có — import **không tự tạo** | Tạo trước ở *Sản phẩm → Đơn vị tính*, tên trùng khớp tuyệt đối |
| `Tax with name X in row no. N not found` | Thuế suất chưa có — không tự tạo | Tạo trước ở *Cài đặt → Thuế suất* |
| `No location with name 'X' found in row no. N` | Sai tên chi nhánh (thừa khoảng trắng, sai dấu, sai hoa thường) | Copy tên **y hệt** từ *Cài đặt → Chi nhánh* |
| `Dòng N: không tìm thấy sản phẩm có SKU "X" trong danh mục.` | Nhập tồn đầu kỳ trước khi nhập sản phẩm, hoặc SKU lệch | Nhập sản phẩm trước; kiểm tra SKU có khoảng trắng thừa không |
| `Dòng N: sản phẩm "X" chưa bật "Quản lý tồn kho".` | Sản phẩm để `MANAGE STOCK = 0` | Sửa sản phẩm sang có quản lý tồn, hoặc bỏ dòng đó khỏi file tồn kho |

## Lỗi giá trị sai định dạng

| Thông báo | Nguyên nhân | Cách sửa |
|---|---|---|
| `Dòng N: GIÁ VỐN "1.500.000" (cột 4) không phải là số.` | Màn tồn đầu kỳ chỉ nhận **số thuần** | Bỏ hết dấu ngăn nghìn: `1500000` |
| `Dòng N: SỐ LƯỢNG (cột 3) đang trống hoặc không phải là số.` | Ô trống, hoặc có chữ/ký tự lẫn vào | Điền số thuần; ô trống ≠ số 0 |
| `Invalid value for MANAGE STOCK in row no. N` | Điền chữ (`Có`/`yes`) thay vì `1`/`0` | Chỉ dùng `1` hoặc `0` |
| `Invalid value for PRODUCT TYPE in row no. N` | Không phải `single`/`variable` | Ghi đúng chữ thường tiếng Anh |
| `Invalid value for Selling Price Tax Type in row no. N` | Không phải `inclusive`/`exclusive` | Ghi đúng chữ thường tiếng Anh |
| `X barcode type is not valid in row no. N` | Loại mã vạch không được hỗ trợ | Để trống, hoặc dùng đúng loại trong hướng dẫn trên màn hình |
| `Invalid value for ENABLE IMEI OR SERIAL NUMBER in row no. N` | Không phải `1`/`0` | Sửa về `1`/`0` |
| Cả lần import chết, không rõ dòng nào | Thường do **ngày sai định dạng** (`Carbon` ném lỗi) | Nhớ: Sản phẩm dùng `m-d-Y`, Tồn đầu kỳ dùng định dạng của doanh nghiệp |

## Lỗi thiếu dữ liệu bắt buộc

| Thông báo | Cách sửa |
|---|---|
| `Thiếu tên hàng ở dòng N (hoặc điền Hiệu + Size + Mã để hệ thống tự ghép tên)` | Điền cột NAME, hoặc điền đủ BRAND + custom field để ghép tên |
| `UNIT is required in row no. N` | Cột 3 bắt buộc |
| `PURCHASE PRICE is required in row no. N` | Phải có giá vốn ở cột 17 **hoặc** 18 |
| `VARIATION NAME is required in row no. N` / `VARIATION VALUES are required` | Hàng `variable` bắt buộc có tên và giá trị biến thể |
| `Dòng N: thiếu MÃ SKU (cột 1).` | Cột SKU của file tồn đầu kỳ là bắt buộc |
| `Dòng N: thiếu GIÁ VỐN chưa thuế (cột 4).` | Bắt buộc, kể cả bằng 0 thì cũng phải ghi `0` |
| `LOCATION (Chi nhánh) is required for opening stock because this business has multiple branches - missing in row no. N` | Doanh nghiệp nhiều chi nhánh → cột chi nhánh bắt buộc |
| `Dòng N: bắt buộc nhập CHI NHÁNH (cột 2) vì doanh nghiệp có nhiều chi nhánh.` | Như trên, ở màn tồn đầu kỳ |

## Lỗi công nợ đầu kỳ

| Thông báo | Nghĩa | Cách xử lý |
|---|---|---|
| `Dòng N: TK 'X' không phải 131/331 — bỏ qua.` | Dòng thuộc tài khoản khác | Bình thường, không phải lỗi. Muốn nhập số dư tài khoản khác thì dùng *Kế toán → Nhập số dư đầu kỳ* |
| `Không tìm thấy dòng nào có số dư cuối kỳ.` | File không có cột "Số dư cuối kỳ", hoặc bảng nằm ở sheet khác | Kiểm tra đúng sheet; hoặc chuyển sang mẫu rút gọn 4 cột |
| `Dòng N: cột Loại phải là 1, 2, 3 hoặc 4.` | Sai mã chiều công nợ | Xem bảng 4 chiều trong SKILL.md |
| `Dòng N (X): số tiền phải lớn hơn 0.` | Ghi số âm để thể hiện chiều | Chiều nằm ở cột Loại — số tiền luôn dương |
| `Dòng N: "X" ĐÃ có nợ đầu kỳ — bỏ qua để không nhân đôi.` | Đối tượng đã được nhập nợ đầu kỳ trước đó | Đúng thiết kế. Muốn sửa số thì sửa trên chứng từ đã có, đừng nhập lại |
| `Dòng N: "X" có nợ ở cả 131 và 331 — đã tách hồ sơ "Y" để không bù trừ hai tài khoản.` | Cùng pháp nhân vừa là khách vừa là NCC | Đúng thiết kế. Xác nhận với kế toán có muốn bù trừ không — nếu có thì phải làm bút toán riêng |
| Chạy thử báo nhiều đối tượng "chưa khớp" | Khách/NCC chưa có trong hệ thống | Import danh sách khách/NCC trước (bước 6), rồi chạy thử lại |

## Khi lỗi vượt quá 50 dòng

Màn tồn kho đầu kỳ chỉ hiện **tối đa 50 lỗi** một lần. Sửa hết 50 lỗi đó rồi chạy lại để lộ phần
còn lại. Nếu lỗi quá nhiều, thường là lỗi hệ thống chứ không phải lỗi từng dòng — kiểm tra lại:
thứ tự nhập, định dạng số, tên chi nhánh.

## Import đã chạy rồi mới phát hiện sai

**Không có nút hoàn tác.** Thứ tự xử lý:

1. **Dừng ngay**, không nhập tiếp file khác.
2. Xác định phạm vi: bao nhiêu dòng đã ghi, thuộc chứng từ loại gì.
3. Nếu vừa mới import và có backup trước đó → **restore backup** là sạch nhất
   (`deployments/restore-tenant.sh`, xem skill `bos-operations`).
4. Nếu không thể restore (đã phát sinh giao dịch mới sau đó) → xoá tay từng chứng từ theo đúng
   thứ tự ngược: chứng từ phụ thuộc trước, chứng từ gốc sau.
5. Ghi lại nguyên nhân vào nhật ký vận hành để lần sau không lặp.

## Kiểm tra sau import (bắt buộc)

| Loại dữ liệu | Đối chiếu gì |
|---|---|
| Sản phẩm | Tổng số dòng file = tổng sản phẩm mới tạo |
| Tồn đầu kỳ | Tổng số lượng và tổng giá trị tồn theo **từng chi nhánh** |
| Khách/NCC | Tổng số đối tượng, và không có bản trùng tên |
| Công nợ đầu kỳ | Tổng 4 chiều khớp với sổ kế toán; tổng 131/331 khớp với số dư sổ cái |
| Đối soát sàn | Danh sách cột phí `unknown`, và số dòng `unmatched` |
