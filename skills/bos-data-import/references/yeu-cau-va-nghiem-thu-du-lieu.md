# Xin dữ liệu của khách và nghiệm thu khi nhận

> Dành cho người mới: đây là việc làm **trước** khi làm sạch dữ liệu. Bỏ qua bước này thì thường
> mất 2–3 ngày làm sạch rồi mới phát hiện file thiếu cột, phải quay lại xin khách từ đầu.

## Phần 1 — Xin gì ở khách

### Nguyên tắc trước khi soạn tin nhắn

- **Xin file gốc xuất từ phần mềm cũ**, không xin file khách "làm lại cho gọn". File khách tự gõ tay
  luôn sai nhiều hơn file máy xuất ra.
- **Xin định dạng Excel hoặc CSV.** Không nhận PDF, ảnh chụp, bản in. Không nhận báo cáo đã gộp dòng
  hay đã trộn ô.
- **Xin một lần đủ hết**, đừng xin nhỏ giọt. Khách bận, mỗi lần hỏi lại là mất thêm vài ngày.
- **Chốt ngày mốc trước khi xin.** Mọi số dư phải cùng một mốc — hết ngày liền trước ngày cắt chuyển.
  Nhận file mỗi loại một mốc là không đối chiếu được với nhau.

### Mẫu tin nhắn gửi khách

> Chào anh/chị,
>
> Để chuẩn bị đưa hệ thống vào chạy từ ngày **(ngày cắt chuyển)**, bên em xin anh/chị các dữ liệu sau,
> tất cả chốt số đến **hết ngày (ngày liền trước)**:
>
> **Bắt buộc — không có thì chưa chạy được:**
> 1. **Danh mục hàng hoá** — tên hàng, mã hàng (SKU), đơn vị tính, nhóm hàng, giá vốn, giá bán
> 2. **Tồn kho hiện tại** — theo từng kho/chi nhánh: mã hàng, số lượng, giá vốn
> 3. **Danh sách khách hàng và nhà cung cấp** — tên, mã (hoặc mã số thuế), điện thoại, địa chỉ
> 4. **Công nợ phải thu và phải trả** — chi tiết theo từng khách/nhà cung cấp
> 5. **Danh sách chi nhánh/kho** — tên chính xác như anh/chị muốn hiển thị trên hệ thống
> 6. **Danh sách nhân viên** cần cấp tài khoản — họ tên, số điện thoại, làm ở chi nhánh nào, phụ trách việc gì
>
> **Nếu có thì gửi thêm:**
> 7. Số dư các tài khoản kế toán đầu kỳ (bảng cân đối phát sinh)
> 8. Danh sách tài sản cố định, công cụ dụng cụ
> 9. Bảng giá riêng cho từng nhóm khách (nếu có áp dụng)
> 10. Danh sách đơn hàng chưa giao xong / chưa thu tiền xong tính đến ngày chốt
>
> Anh/chị **xuất thẳng từ phần mềm đang dùng** ra file Excel gửi em là được ạ, không cần chỉnh sửa
> hay làm gọn lại — bên em sẽ tự xử lý phần đó.
>
> Nhờ anh/chị cho em biết **ai là người bên mình chốt số liệu** để em trao đổi trực tiếp khi cần
> đối chiếu ạ.

### Câu hỏi phải hỏi kèm

| Hỏi | Vì sao |
|---|---|
| Mã khách hàng trong sổ dùng mã nội bộ hay mã số thuế? | Phải chọn **một** làm khoá khớp. File thực tế hay lẫn cả hai kiểu → khớp sai đối tượng |
| Tên chi nhánh chốt chưa, có đổi nữa không? | Tên chi nhánh đi vào mọi file. Đổi sau khi đã nhập là làm lại từ đầu |
| Tồn kho đã kiểm kê thực tế chưa? | Nhập tồn theo sổ trong khi thực tế lệch → sai từ ngày đầu, và sẽ đổ lỗi cho phần mềm |
| Có hàng theo lô / hạn sử dụng / số IMEI không? | Ảnh hưởng cấu trúc file và cấu hình sản phẩm |
| Giá bán có nhiều mức theo nhóm khách không? | Quyết định có cần bảng giá riêng |

## Phần 2 — Nghiệm thu file khi khách gửi tới

Làm trong **15 phút**, trước khi bắt tay vào làm sạch. Mục tiêu chỉ là trả lời một câu:
**nhận được, hay trả lại xin bổ sung?**

### Bước 1 — Kiểm nhanh cả bộ (2 phút)

- [ ] Đủ **6 loại bắt buộc** chưa? Thiếu loại nào → hỏi ngay, đừng đợi làm xong loại khác
- [ ] Tất cả có cùng **một mốc ngày chốt** không?
- [ ] Có file nào là PDF/ảnh không? → trả lại xin bản Excel
- [ ] Mở được bằng Excel không, có bị khoá mật khẩu không?

### Bước 2 — Kiểm từng file (3 phút/file)

| Kiểm | Đạt | Không đạt → làm gì |
|---|---|---|
| Dòng tiêu đề nằm ở **dòng đầu tiên** | Có | Có nhiều dòng tiêu đề/logo phía trên → tự xoá được, ghi nhận |
| **Ô bị trộn (merge)** | Không có | Có → trả lại xin bản không trộn ô, hoặc tự tách nếu ít |
| **Cột bắt buộc** có đủ không (xem `ban-do-cot.md`) | Đủ | Thiếu → **trả lại xin bổ sung**, đây là lý do trả lại chính đáng nhất |
| **Số dòng dữ liệu** | Đếm và ghi lại | Ít hơn khách nói nhiều → hỏi lại, có thể xuất thiếu bộ lọc |
| **Mã hàng / mã khách bị trùng** | Không trùng | Có trùng → gửi danh sách trùng, hỏi khách giữ dòng nào |
| **Mã bị bỏ trống** | Không trống | Trống nhiều → hỏi khách có mã không, hay để hệ thống tự sinh |
| **Tổng số tiền / tổng số lượng** | Ghi lại con số | Đây là số dùng để đối chiếu sau khi nhập — **bắt buộc phải có** |

### Bước 3 — Kiểm chéo giữa các file (5 phút)

Đây là bước hay bị bỏ, và là bước bắt được lỗi đắt nhất:

- [ ] **Tên chi nhánh trong file tồn kho** có trùng khớp với danh sách chi nhánh khách gửi không?
      (kể cả dấu tiếng Việt và hoa/thường)
- [ ] **Mã hàng trong file tồn kho** có nằm hết trong file danh mục hàng hoá không?
      → Thiếu mã nào là mã đó sẽ lỗi khi nhập
- [ ] **Tên khách trong file công nợ** có nằm hết trong file danh sách khách hàng không?
      → Đây là lỗi kinh điển: sổ kế toán có 420 khách nhưng danh sách gửi sang chỉ có 35
- [ ] Tổng công nợ chi tiết có khớp tổng trên bảng cân đối không (nếu khách gửi cả hai)?

### Bước 4 — Kết luận

Chỉ có 3 kết luận, ghi rõ ra:

| Kết luận | Khi nào | Làm gì tiếp |
|---|---|---|
| **Nhận đủ** | Đủ 6 loại bắt buộc, cột đủ, kiểm chéo sạch | Vào làm sạch dữ liệu (SKILL.md) |
| **Nhận được nhưng thiếu phần phụ** | Đủ loại bắt buộc, thiếu mục 7–10 | Vào làm sạch phần có, xin song song phần thiếu |
| **Trả lại xin bổ sung** | Thiếu loại bắt buộc, hoặc thiếu cột bắt buộc, hoặc kiểm chéo hụt nhiều | Gửi khách danh sách thiếu **cụ thể**, đừng nói chung chung |

## Phần 3 — Mẫu trả lời khi file thiếu

Nguyên tắc: **nói cụ thể thiếu gì, thiếu bao nhiêu, và hậu quả nếu không có** — đừng nói "file chưa
đúng chuẩn" rồi để khách tự đoán.

> Anh/chị ơi, em đã kiểm file rồi ạ. File **(tên file)** dùng tốt, em ghi nhận **(số)** dòng.
>
> Còn thiếu mấy phần này ạ:
>
> 1. **File tồn kho thiếu cột giá vốn.** Không có giá vốn thì hệ thống không tính được lãi lỗ khi
>    bán hàng. Nhờ anh/chị xuất lại kèm cột này giúp em.
> 2. **File công nợ có 59 khách chưa nằm trong danh sách khách hàng.** Em gửi kèm danh sách 59 tên
>    này ạ — nhờ anh/chị bổ sung vào file khách hàng, vì phần mềm chỉ ghi nợ cho khách đã có hồ sơ.
> 3. **Tên chi nhánh giữa hai file đang khác nhau**: file tồn ghi "Kho HN", danh sách chi nhánh ghi
>    "Chi nhánh Hà Nội". Nhờ anh/chị chốt giúp em dùng tên nào để em thống nhất toàn bộ ạ.
>
> Có ba phần này là em chạy tiếp được ngay ạ.

Luôn **gửi kèm danh sách cụ thể** (59 tên, mã nào trùng) chứ không bắt khách tự đi tìm — khách tự
tìm thì thường mất một tuần và tìm thiếu.

## Phần 4 — Bảng đủ/thiếu: tối thiểu để chạy được

Khi khách hối go-live mà dữ liệu chưa đủ, dùng bảng này để nói chuyện — cái gì thật sự chặn, cái gì bổ sung sau được:

| Dữ liệu | Không có thì | Bổ sung sau được không |
|---|---|---|
| Danh mục hàng hoá | **Không bán được** | Không — phải có trước |
| Chi nhánh | **Không nhập được gì** | Không — phải có trước và không đổi tên |
| Đơn vị tính, thuế suất | Import sản phẩm lỗi toàn bộ | Không — phải tạo trước |
| Tồn kho đầu kỳ | Bán được nhưng **tồn âm**, giá vốn sai | Được, nhưng phải xong **trước ngày cắt chuyển** |
| Khách hàng / NCC | Bán được cho khách lẻ, không theo dõi được công nợ | Được, thêm dần khi phát sinh |
| Công nợ đầu kỳ | Báo cáo công nợ **thiếu số cũ**, đối chiếu với khách sai | Được, nhưng càng để lâu càng khó chốt |
| Số dư sổ cái | Báo cáo tài chính không đủ | Được — kế toán thường chốt sau |
| Tài sản cố định | Không tính khấu hao | Được |
| Bảng giá riêng | Bán theo giá chung | Được |
| Đơn dở dang | Phải nhập tay lại vài đơn | Được nếu số lượng ít |

**Ba dòng đầu là điều kiện cần tuyệt đối.** Thiếu ba dòng này mà vẫn go-live là hỏng chắc — nói rõ
với khách và với quản lý, đừng nhận đại rồi chữa sau.

## Phần 5 — Biên bản bàn giao dữ liệu

Mỗi lần nhận dữ liệu, ghi lại (một bảng trong file quản lý dự án là đủ):

| Mục | Nội dung |
|---|---|
| Ngày nhận | |
| Người gửi bên khách | |
| Tên file | |
| Loại dữ liệu | |
| Số dòng | |
| Tổng tiền / tổng số lượng | ← con số dùng đối chiếu sau khi nhập |
| Mốc ngày chốt số | |
| Kết luận nghiệm thu | Nhận đủ / thiếu phụ / trả lại |
| Phần còn thiếu | |

Con số **tổng tiền và số dòng** là quan trọng nhất. Sau khi nhập xong, đối chiếu lại chính hai con
số này — lệch một đồng cũng phải tìm ra nguyên nhân. Không ghi lại từ đầu thì sau này không có gì để so.
