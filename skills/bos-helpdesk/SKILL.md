---
name: bos-helpdesk
description: >
  Quy trình tiếp nhận và xử lý sự cố khách hàng cho nền tảng BOS — phân loại mức độ, hỏi đúng câu
  hỏi để lấy đủ thông tin, chẩn đoán theo triệu chứng (đơn không lên, tiền về không tự xác nhận,
  webhook lỗi chữ ký, sàn không đồng bộ, màn hình trắng/500, mất quyền truy cập, hoá đơn điện tử
  không phát hành), biết việc nào tự xử lý được và việc nào phải chuyển kỹ thuật, kèm mẫu trả lời
  khách. USE WHEN người dùng nói: khách báo lỗi, hỗ trợ khách hàng BOS, support ticket, sự cố,
  đơn không lên, tiền về không tự xác nhận, đồng bộ lỗi, lỗi 500, khách không đăng nhập được,
  triage, phân loại sự cố, chẩn đoán lỗi BOS.
user-invocable: true
when_to_use: "Dùng khi tiếp nhận một sự cố khách báo trên nền tảng BOS và cần phân loại, chẩn đoán nguyên nhân, quyết định tự xử lý hay leo thang, và trả lời khách."
category: operations
keywords: [bos, helpdesk, support, sự-cố, triage, chẩn-đoán, webhook, dong-bo, hoa-don-dien-tu]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# BOS · Tiếp nhận và xử lý sự cố (Helpdesk)

## Bước 1 — Lấy đủ thông tin trước khi động vào hệ thống

Không có 5 thông tin này thì mọi chẩn đoán đều là đoán mò:

1. **Khách nào / tên miền nào** — mỗi khách một máy chủ riêng, cấu hình khác nhau
   (danh sách ở `deployments/*/config.json`).
2. **Màn hình nào, thao tác gì** — đường dẫn URL đầy đủ nếu có.
3. **Lúc nào** — ngày giờ cụ thể, để tra log đúng khoảng.
4. **Ảnh chụp màn hình** kèm thông báo lỗi nguyên văn.
5. **Có phải mới xảy ra không** — trước đó chạy đúng, hay chưa bao giờ chạy được.
   Trả lời câu này quyết định hướng tìm: *mới hỏng* → nhìn thay đổi gần nhất (deploy, đổi cấu hình,
   hết hạn token); *chưa bao giờ chạy* → nhìn cấu hình và phân quyền.

Thêm khi liên quan tiền: **mã đơn / số chứng từ**, số tiền, thời điểm chuyển khoản.

## Bước 2 — Phân loại mức độ

| Mức | Dấu hiệu | Cam kết xử lý |
|---|---|---|
| **P1 — Nghiêm trọng** | Cả hệ thống không vào được · Không bán được hàng · Sai tiền/sai tồn trên diện rộng · Lộ dữ liệu | Vào việc ngay, báo kỹ thuật lập tức |
| **P2 — Nặng** | Một phân hệ hỏng · Đồng bộ đứng · Hoá đơn không phát hành được · Một nhóm người dùng không thao tác được | Trong ngày |
| **P3 — Thường** | Một chức năng lỗi nhưng có cách làm vòng · Sai lệch số liệu một vài chứng từ | 1–3 ngày |
| **P4 — Nhẹ** | Góp ý giao diện, đề xuất tính năng, hỏi cách dùng | Xếp hàng đợi |

Nguyên tắc: **cứ đụng đến tiền hoặc tồn kho thì nâng ít nhất một mức.**

## Bước 3 — Chẩn đoán theo triệu chứng

### Tiền đã về tài khoản nhưng đơn vẫn "chưa thanh toán"

Đây là ca phổ biến nhất. **Đúng thiết kế:** trong BOS, khách hàng và nhân viên **không được tự bấm
xác nhận đã thanh toán**. Trạng thái *đã thanh toán* chỉ đến từ (a) webhook ngân hàng/cổng thanh
toán đã xác thực chữ ký, hoặc (b) quản trị viên xác nhận trên màn quản trị.

Thứ tự kiểm tra:

1. **Webhook có tới không** — xem log ứng dụng quanh thời điểm chuyển khoản.
2. **Chữ ký có hợp lệ không** — nếu log ghi `401 Invalid signature`: sai `webhook_secret`, sai header
   (`X-Sepay-Signature` / `X-Signature`), hoặc payload bị sửa dọc đường. ⚠️ **Tuyệt đối không nới
   lỏng kiểm tra chữ ký để "cho chạy tạm"** — đó là lỗ hổng cho phép người ngoài giả lệnh báo có tiền.
3. **Số tiền có khớp không** — hệ thống **từ chối** đánh dấu đã thanh toán nếu số tiền lệch.
   Khách chuyển thiếu/thừa là đơn đứng nguyên, đúng thiết kế.
4. **Đã xử lý rồi nhưng bị coi là trùng** — có chốt chặn chống trùng theo khoá idempotency; webhook
   gửi lại lần hai sẽ trả về kết quả cũ chứ không xử lý lại.
5. Nếu tiền thật đã về mà webhook không tới: **quản trị viên xác nhận tay** trên màn quản trị
   (không phải trên máy khách hàng), rồi báo kỹ thuật điều tra vì sao webhook trượt.

### Đơn từ sàn (Shopee/TikTok/Lazada/Sapo/Woo) không về

1. Kết nối còn hiệu lực không — **token sàn hết hạn** là nguyên nhân số một.
   Có lệnh làm mới token định kỳ (`marketplace:maintenance --tokens`).
2. Webhook phía sàn còn trỏ đúng địa chỉ không (khách hay đổi tên miền mà quên báo).
3. Xem log đồng bộ của module tương ứng; các module có lệnh kiểm tra sức khoẻ riêng
   (ví dụ `kiotvietsync:health`, `amissync:reconcile`).
4. Có hàng chờ xử lý lại không — nhiều module có lệnh `retry` (`amissync:retry`, `kiotvietsync:retry`).
5. **Hàng đợi (queue) có chạy không** — queue chết thì mọi đồng bộ nằm im mà không báo lỗi.
   Xem skill `bos-operations`.

### Màn hình trắng, lỗi 500, hoặc bấm nút không có gì xảy ra

1. Hỏi chính xác đường dẫn URL.
2. Xem log ứng dụng của đúng khách đó (`log_paths.laravel` trong `config.json`).
3. Nếu **vừa deploy xong** → khả năng cao là bộ nhớ đệm cấu hình/route cũ; chuyển kỹ thuật chạy
   `optimize:clear`.
4. Nếu lỗi liên quan tên lớp/mô-đun không tồn tại → **module bị tắt nhưng màn hình vẫn còn link**.
   Chạy quét toàn hệ thống bằng skill `bos-health-check` có sẵn trong repo BOS.
5. Nếu chỉ một người dùng gặp → nghiêng về **phân quyền**, không phải lỗi mã.

### Chức năng "biến mất" khỏi menu

Không phải lỗi: mỗi khách chỉ bật những phân hệ đã mua. Màn hình thiếu phân hệ tương ứng thì **tự ẩn**
thay vì để nút chết. Kiểm tra danh sách phân hệ đang bật của khách đó (`active_modules` trong
`config.json`, hoặc `modules_statuses.json` trên máy chủ). Nếu khách đã mua mà chưa bật → yêu cầu
kỹ thuật bật, đây là thao tác có kiểm soát chứ không tự ý bật.

### Hoá đơn điện tử không phát hành

1. Cấu hình nhà cung cấp hoá đơn của khách đó đã điền đủ và đăng nhập được chưa.
2. Thông tin người mua có hợp lệ không — **khách vãng lai** thiếu tên/MST là ca lỗi đã từng gặp.
3. Có tiến trình tự phát hành chạy nền (`einvoice:auto-process`) — kiểm tra nó có chạy không.
4. Sai dữ liệu gốc (tên hàng, đơn vị tính, thuế suất) thì cơ quan thuế từ chối — sửa dữ liệu rồi phát hành lại.

### Đăng nhập được nhưng không thấy dữ liệu / thấy dữ liệu sai chi nhánh

Gần như luôn là **phân quyền hoặc phạm vi chi nhánh** của tài khoản, không phải mất dữ liệu.
Kiểm tra vai trò, chi nhánh được gán, và **doanh nghiệp đang chọn** nếu khách có nhiều pháp nhân.

### Số liệu báo cáo không khớp

Trước khi kết luận "phần mềm sai", xác định **báo cáo nào, kỳ nào, lọc theo gì**. Các nguồn lệch
thường gặp: khác kỳ (theo ngày chứng từ vs ngày ghi sổ), khác chi nhánh, có/không gồm đơn huỷ,
giá vốn theo phương pháp nào. Xem skill `bos-business-logic`.

## Bước 4 — Tự xử lý hay chuyển kỹ thuật

**Vận hành tự xử lý được:**
- Hướng dẫn thao tác, sửa dữ liệu nhập sai, tạo lại chứng từ.
- Xác nhận thanh toán tay trên màn quản trị (khi tiền thật đã về).
- Sửa và nhập lại file import (xem skill `bos-data-import`).
- Kiểm tra và điều chỉnh phân quyền, chi nhánh của người dùng.

**Phải chuyển kỹ thuật:**
- Bất kỳ lỗi 500 nào, hoặc lỗi lặp lại trên nhiều tài khoản.
- Webhook sai chữ ký, đồng bộ đứng sau khi đã thử `retry`.
- Sai lệch tiền/tồn mà không truy được nguyên nhân từ chứng từ.
- Bật/tắt phân hệ, đổi cấu hình máy chủ, chạy lệnh trên máy chủ.
- **Mọi việc cần vào máy chủ** — vận hành không tự SSH.

**Không bao giờ làm, kể cả khi khách hối:**
- Nới lỏng hoặc tắt kiểm tra chữ ký webhook.
- Mở lại đường cho khách/nhân viên tự xác nhận đã thanh toán.
- Sửa thẳng vào cơ sở dữ liệu để "cho nhanh".
- Xoá dữ liệu khi chưa có bản sao lưu và chưa có xác nhận bằng văn bản của khách.

## Bước 5 — Trả lời khách

Mẫu ngắn, dùng được ngay:

> **Đã tiếp nhận** — Bên em đã ghi nhận sự việc *(mô tả lại đúng vấn đề khách nêu)*.
> Mức độ: *(P1/P2/P3)*. Bên em đang kiểm tra và sẽ phản hồi trước *(mốc thời gian cụ thể)*.

> **Đang xử lý** — Nguyên nhân là *(nói bằng ngôn ngữ nghiệp vụ, không nói tên hàm/tên bảng)*.
> Bên em đang *(việc đang làm)*. Trong lúc chờ, anh/chị có thể *(cách làm tạm nếu có)*.

> **Đã xử lý** — Việc *(vấn đề)* đã xong lúc *(giờ)*. Nguyên nhân: *(ngắn gọn)*.
> Để không lặp lại, bên em đã *(biện pháp)*. Nhờ anh/chị kiểm tra lại giúp em ạ.

Nguyên tắc viết: nói **kết quả và mốc thời gian**, không nói chi tiết kỹ thuật. Không hứa mốc chưa
chắc chắn. Nếu trễ hẹn thì chủ động báo trước khi khách hỏi.

## Bước 6 — Đóng ticket

- Xác nhận **khách đã kiểm tra lại và đồng ý đóng**, không tự đóng.
- Nếu là lỗi dữ liệu do nhập sai → ghi lại vào nhật ký vận hành để rút kinh nghiệm.
- Nếu là lỗi hệ thống lặp lại lần thứ hai → **không đóng suông**, phải mở việc xử lý gốc cho kỹ thuật.
- Ca mới chưa có trong tài liệu này → bổ sung vào bảng triệu chứng ở trên, đó là cách skill này lớn lên.
