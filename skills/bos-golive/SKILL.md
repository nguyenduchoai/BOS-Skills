---
name: bos-golive
description: >
  Quy trình đưa một khách hàng mới lên chạy thật trên nền tảng BOS — từ khảo sát nghiệp vụ, chọn
  phân hệ cần bật, dựng danh mục nền, nhập dữ liệu đầu kỳ đúng thứ tự, phân quyền, chạy song song
  đối chiếu, đến ngày cắt chuyển và chăm sóc tuần đầu. Kèm bảng nghiệm thu trước khi tuyên bố
  go-live và các sai lầm khiến dự án triển khai đổ vỡ. USE WHEN người dùng nói: triển khai khách mới,
  go-live, onboarding khách hàng BOS, chuyển từ phần mềm cũ, setup hệ thống cho khách, khách mới lên
  hệ thống, cắt chuyển dữ liệu, chạy song song.
user-invocable: true
when_to_use: "Dùng khi triển khai một khách hàng mới lên BOS hoặc chuyển khách từ phần mềm cũ sang, cần biết làm gì trước làm gì sau và nghiệm thu ra sao."
category: operations
keywords: [bos, golive, trien-khai, onboarding, cat-chuyen, du-lieu-dau-ky, nghiem-thu, chay-song-song]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# BOS · Đưa khách hàng mới lên chạy thật

Triển khai hỏng hiếm khi vì phần mềm thiếu chức năng. Hỏng vì **dữ liệu đầu kỳ sai** và vì **cắt
chuyển vội khi người dùng chưa sẵn sàng**. Quy trình dưới đây chống đúng hai thứ đó.

## Giai đoạn 1 — Khảo sát trước khi đụng vào hệ thống

Phải trả lời xong những câu này, bằng văn bản, có khách xác nhận:

| Câu hỏi | Vì sao phải hỏi trước |
|---|---|
| Bao nhiêu chi nhánh, tên chính xác là gì | Tên chi nhánh đi vào **mọi file nhập liệu** và phải trùng khớp tuyệt đối. Đổi tên sau khi đã nhập là làm lại |
| Một hay nhiều pháp nhân | Quyết định có bật phân hệ nhiều pháp nhân và hợp nhất nhóm hay không |
| Bán những kênh nào | Quầy, Zalo MiniApp, website, sàn TMĐT — mỗi kênh một phân hệ và một luồng đối soát |
| Thu tiền kiểu gì | Tiền mặt, chuyển khoản, COD, cổng thanh toán — quyết định cấu hình đối soát |
| Có xuất hoá đơn điện tử không, nhà cung cấp nào | Cần cấu hình và thử phát hành trước ngày cắt chuyển |
| Đang dùng phần mềm gì, xuất được dữ liệu gì | Quyết định khối lượng công việc làm sạch dữ liệu |
| **Ngày cắt chuyển dự kiến** | Mọi số dư đầu kỳ đều tính đến hết ngày liền trước ngày này |
| Ai là người chốt số liệu bên khách | Không có người này thì không ai xác nhận được số đầu kỳ đúng hay sai |

Chốt luôn **khoá khớp đối tượng**: mã khách hàng nội bộ hay mã số thuế? Chọn **một** và dùng thống
nhất cho toàn bộ file. Kinh nghiệm thật: file kế toán hay lẫn cả hai kiểu, gây khớp sai đối tượng.

## Giai đoạn 2 — Dựng nền

Thứ tự bắt buộc, làm sai thứ tự là file đúng vẫn báo lỗi hàng loạt:

```
1. Tạo doanh nghiệp, chọn định dạng ngày và tiền tệ   ← chốt ngay, mọi file nhập sau phải theo
2. Tạo chi nhánh                                       ← tên chốt cuối cùng, không đổi nữa
3. Bật đúng những phân hệ khách mua
4. Tạo đơn vị tính và thuế suất                        ← import sản phẩm KHÔNG tự tạo hai thứ này
5. Tạo vai trò và tài khoản người dùng
6. Cấu hình tích hợp: thanh toán, hoá đơn điện tử, sàn
```

**Định dạng ngày và tiền tệ phải chốt ở bước 1.** Nhiều màn nhập liệu đọc số và ngày theo đúng cấu
hình này; đổi giữa chừng sẽ làm sai toàn bộ dữ liệu đã nhập trước đó.

Bật phân hệ: chỉ bật thứ khách thực sự mua. Màn hình thiếu phân hệ sẽ tự ẩn — bật thừa chỉ làm
người dùng rối và tăng bề mặt lỗi.

## Giai đoạn 3 — Nhập dữ liệu đầu kỳ

Chi tiết cách làm sạch từng loại file: skill `bos-data-import`. Ở đây là **thứ tự và mốc chốt số**.

```
Danh mục hàng hoá  →  Tồn kho đầu kỳ  →  Khách hàng & NCC  →  Công nợ đầu kỳ  →  Số dư sổ cái
```

**Mốc chốt số**: mọi số dư đầu kỳ tính đến **hết ngày liền trước ngày cắt chuyển**. Số dư "cuối kỳ"
của phần mềm cũ chính là số dư "đầu kỳ" của BOS.

Nguyên tắc bắt buộc ở giai đoạn này:

- **Sao lưu trước mỗi lần nhập lớn.** Nhập liệu không có nút hoàn tác.
- Màn nào có **Chạy thử** thì chạy thử đến khi sạch lỗi mới ghi sổ.
- Nhập xong mỗi loại thì **đối chiếu tổng ngay**, đừng dồn đến cuối:
  tổng số dòng, tổng số lượng, tổng tiền — so với file gốc và với xác nhận của kế toán khách.
- Người chốt số liệu bên khách phải **ký xác nhận từng loại** trước khi sang loại tiếp theo.

Sai lầm hay gặp: nhập công nợ khi danh sách khách/NCC chưa đủ. Một dự án thật đã gặp: sổ kế toán có
420 khách và 82 nhà cung cấp, hệ thống mới có 35 và 33 — chạy thử báo hàng chục đối tượng chưa khớp,
phải quay lại làm bước trước.

## Giai đoạn 4 — Đào tạo và chạy song song

**Đào tạo theo vai trò, không đào tạo theo màn hình.** Thu ngân chỉ cần biết việc của thu ngân.
Mỗi vai trò một buổi ngắn, làm thật trên dữ liệu thật của họ, không dùng ví dụ tưởng tượng.

**Chạy song song** — nhập cả phần mềm cũ và BOS trong 1–2 tuần. Đây là bước hay bị cắt để "cho nhanh",
và cũng là bước cứu dự án nhiều nhất. Mỗi cuối ngày đối chiếu 3 con số:

1. Doanh thu trong ngày
2. Tồn kho vài mặt hàng bán chạy
3. Số tiền thực thu theo từng hình thức thanh toán

Lệch thì tìm cho ra nguyên nhân **trong ngày**, đừng để dồn. Lệch dồn vài ngày là không truy được nữa.

Điều phải giải thích cho người dùng ngay từ buổi đầu, nếu không họ sẽ báo là "lỗi":

- Chứng từ **nháp không trừ tồn kho** — phải hoàn tất mới trừ.
- Đơn **hoàn tất nhưng chưa thu tiền vẫn trừ tồn** — hàng đã giao.
- **Không ai tự bấm được "đã thanh toán"** ngoài quản trị viên; tiền về tự động thì hệ thống tự ghi.
- Chức năng không thấy trong menu là **phân hệ chưa bật**, không phải mất.
- Chi tiết vì sao: skill `bos-business-logic`.

## Giai đoạn 5 — Ngày cắt chuyển

- Chọn ngày **đầu kỳ kế toán** (đầu tháng, đầu quý), tránh cao điểm bán hàng.
- Tránh cắt chuyển vào thứ Sáu — hỏng là không có người xử lý cuối tuần.
- Chốt số dư cuối cùng từ phần mềm cũ, nhập bổ sung phần chênh lệch phát sinh trong thời gian
  chạy song song.
- Khoá quyền ghi trên phần mềm cũ, giữ quyền đọc để còn tra cứu lịch sử.
- **Sao lưu toàn bộ ngay trước và ngay sau khi cắt chuyển.**
- Có mặt cùng khách trọn ngày đầu tiên.

## Bảng nghiệm thu trước khi tuyên bố go-live

Không tick đủ thì chưa được coi là xong:

- [ ] Bán được một đơn hoàn chỉnh: tạo đơn → thanh toán → in chứng từ → tồn kho giảm đúng
- [ ] Nhập được một đơn mua: nhập kho → tồn tăng → công nợ NCC ghi đúng
- [ ] Trả hàng bán và trả hàng mua đều chạy đúng
- [ ] Tổng tồn kho khớp với biên bản kiểm kê của khách
- [ ] Tổng công nợ phải thu, phải trả khớp sổ kế toán khách — **cả bốn chiều**
- [ ] Số dư sổ cái khớp với sổ chi tiết theo đối tượng
- [ ] Xuất được hoá đơn điện tử thật (nếu khách dùng)
- [ ] Tiền chuyển khoản về tài khoản → đơn **tự** chuyển sang đã thanh toán
- [ ] Đơn từ sàn/MiniApp về hệ thống đúng (nếu có bán các kênh này)
- [ ] Mỗi vai trò đăng nhập thấy đúng phạm vi của mình, không thừa không thiếu
- [ ] Báo cáo doanh thu, tồn kho, công nợ ra số hợp lý và khách hiểu cách đọc
- [ ] Sao lưu tự động đã chạy và **đã thử phục hồi thành công**
- [ ] Khách biết kênh báo sự cố và biết cần cung cấp thông tin gì

## Giai đoạn 6 — Tuần đầu sau go-live

- **Ngày 1–3**: có người trực riêng cho khách này, phản hồi trong vòng một giờ.
- Cuối mỗi ngày trong tuần đầu: đối chiếu doanh thu và tiền thực thu.
- Cuối tuần đầu: rà nhật ký lỗi, gom các câu hỏi lặp lại thành hướng dẫn ngắn gửi khách.
- Cuối tháng đầu: chốt sổ tháng cùng kế toán khách — đây mới là lúc biết dữ liệu đầu kỳ có đúng không.

## Những sai lầm làm đổ dự án

| Sai lầm | Hậu quả thật |
|---|---|
| Cắt bước chạy song song để kịp tiến độ | Lệch số phát hiện muộn, không truy được nguyên nhân, mất niềm tin |
| Nhập dữ liệu đầu kỳ khi chưa có người chốt số | Không ai chịu trách nhiệm số sai, tranh cãi kéo dài |
| Đổi tên chi nhánh sau khi đã nhập liệu | Toàn bộ file cũ không khớp, phải nhập lại |
| Bật hết mọi phân hệ cho "đầy đủ" | Người dùng rối, bề mặt lỗi tăng, đào tạo dài gấp đôi |
| Nhập công nợ trước khi có đủ danh sách đối tượng | Hàng chục dòng không khớp, phải làm lại từ đầu |
| Không sao lưu trước khi nhập lớn | Nhập sai là không lùi được, phải xoá tay từng chứng từ |
| Đào tạo một buổi cho tất cả mọi người | Ai cũng nghe, không ai nhớ việc của mình |
| Tuyên bố xong khi chưa chốt sổ tháng đầu | Sai dữ liệu đầu kỳ lộ ra sau đó, lúc đã phát sinh cả tháng giao dịch |
