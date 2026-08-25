---
name: bos-operations
description: >
  Sổ tay vận hành hệ thống BOS chạy thật trên nhiều máy chủ khách hàng — việc phải kiểm hằng ngày,
  hàng tuần, hàng tháng; hàng đợi (queue) và tác vụ định kỳ (cron) có những gì và khi nào chúng chết;
  sao lưu và phục hồi đúng cách với kiến trúc mỗi khách một cơ sở dữ liệu; quy tắc an toàn trước và
  sau khi triển khai; bật/tắt phân hệ; xử lý sự cố hạ tầng. USE WHEN người dùng nói: vận hành BOS,
  runbook, cron không chạy, queue chết, backup, phục hồi dữ liệu, restore, kiểm tra sức khoẻ hệ thống,
  deploy BOS, bật module, tác vụ định kỳ, máy chủ khách hàng.
user-invocable: true
when_to_use: "Dùng khi vận hành/giám sát các máy chủ BOS đang chạy thật: kiểm tra định kỳ, xử lý queue/cron, sao lưu–phục hồi, triển khai an toàn, bật tắt phân hệ."
category: operations
keywords: [bos, van-hanh, runbook, cron, queue, backup, restore, deploy, health-check, multi-tenant]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# BOS · Sổ tay vận hành hệ thống

Mỗi khách hàng là **một máy chủ, một cấu hình riêng** — khai báo ở `deployments/<khách>/config.json`
(tên miền, thư mục web, đường dẫn log, phân hệ đang bật). Với nền tảng SaaS thì trong một máy chủ
còn có **nhiều cơ sở dữ liệu**: một cơ sở trung tâm và mỗi khách thuê bao một cơ sở riêng.

Hệ quả quan trọng: **mọi thao tác đều phải hỏi "trên máy chủ nào, cho khách nào"** trước khi làm.

## Kiểm tra định kỳ

### Hằng ngày (10 phút)

| Việc | Cách nhận biết có vấn đề |
|---|---|
| Hàng đợi (queue) còn chạy | Đơn/đồng bộ/email nằm im mà **không có báo lỗi** — dấu hiệu kinh điển của queue chết |
| Sao lưu đêm qua có thành công | Bản sao lưu phải có **đủ số cơ sở dữ liệu**, thiếu một cái là hỏng cả lần sao lưu |
| Log lỗi có gì mới | Lỗi lặp lại nhiều lần trong ngày quan trọng hơn lỗi lạ xuất hiện một lần |
| Đồng bộ sàn/kế toán có đứng | Mỗi phân hệ đồng bộ có lệnh kiểm tra sức khoẻ riêng |
| Thanh toán tự động có về | So số đơn "đã thanh toán tự động" hôm nay với ngày thường |

### Hằng tuần

- Quét toàn bộ đường dẫn tìm lỗi 500 và phân hệ "ma" — dùng skill `bos-health-check` có sẵn trong repo BOS.
- **Thử phục hồi thật** một bản sao lưu vào cơ sở dữ liệu tạm rồi đối chiếu số bảng/số dòng.
  Có file sao lưu **chưa chắc** phục hồi được — chỉ bước này mới trả lời được câu "mất dữ liệu thì
  dựng lại được không".
- Rà token sắp hết hạn của các kết nối sàn.
- Dung lượng đĩa còn bao nhiêu (log và bản sao lưu là hai thứ ăn đĩa nhanh nhất).

### Hằng tháng

- Rà quyền truy cập: ai còn tài khoản mà đã nghỉ việc.
- Rà các phân hệ đang bật nhưng khách không dùng.
- Đối chiếu số liệu tài chính tổng hợp với kế toán của khách.

## Hàng đợi và tác vụ định kỳ

Rất nhiều nghiệp vụ của BOS **chạy nền**, không chạy lúc người dùng bấm nút. Nếu hàng đợi hoặc lịch
chạy chết thì hệ thống *trông vẫn bình thường* nhưng mọi thứ ngừng chảy — đây là loại sự cố nguy
hiểm nhất vì không ai báo lỗi.

Nhóm việc chạy nền chính:

| Nhóm | Ví dụ | Nhịp |
|---|---|---|
| CRM | tính lại RFM, giá trị vòng đời khách, phát hiện nguy cơ rời bỏ, chấm điểm khách tiềm năng | hằng ngày rạng sáng |
| CRM tương tác | gửi tin đã xếp hàng, chạy chiến dịch theo lịch, thực thi hành động đã hẹn | mỗi 5 phút |
| Đồng bộ | kéo/đẩy dữ liệu sàn và phần mềm kế toán, làm mới token, chạy lại việc lỗi | tuỳ phân hệ |
| Hoá đơn điện tử | tự phát hành hoá đơn | định kỳ |
| Nhắc việc | hợp đồng sắp hết hạn, khế ước vay, tài sản, giấy tờ nhân sự, sinh nhật khách | hằng ngày |
| Thuê bao SaaS | nhắc hết hạn gói, sinh hoá đơn thuê bao, huỷ giao dịch treo | hằng ngày |

Các tác vụ quan trọng đều đặt cờ **chỉ chạy trên một máy** và **không chồng lượt** — nên nếu một
lượt bị treo, các lượt sau sẽ **bị chặn im lặng** cho đến khi lượt treo được dọn. Queue đứng lâu
mà không rõ lý do thì kiểm tra khoá chồng lượt này trước.

Khi phát hiện việc chạy nền không chạy:
1. Xác nhận tiến trình chạy nền còn sống trên máy chủ (việc của kỹ thuật).
2. Xem log lỗi quanh thời điểm lượt chạy gần nhất.
3. Chạy lại thủ công đúng lệnh của nhóm việc đó, xem có lỗi hiện ra không.
4. Nhiều phân hệ đồng bộ có lệnh **chạy lại việc lỗi** — dùng lệnh đó thay vì làm tay từng đơn.

## Sao lưu và phục hồi

Nguyên tắc gốc của bộ sao lưu BOS: **thà báo hỏng còn hơn sao lưu thiếu mà im lặng.**

Vì sao không dùng lịch của ứng dụng để sao lưu: ứng dụng hỏng thì lệnh sao lưu chết theo — đúng lúc
cần nhất lại không có. Vì sao không dùng thư viện sao lưu thông dụng: nó chỉ sao lưu cơ sở dữ liệu
mặc định, trong khi mỗi khách thuê bao nằm ở **một cơ sở riêng** — sao lưu kiểu đó **bỏ sót toàn bộ
dữ liệu khách mà vẫn báo thành công**.

```bash
# Sao lưu (chạy thẳng từ lịch của máy, không qua ứng dụng)
deployments/bos-backup.sh <thư_mục_web> [số_ngày_giữ]   # mặc định giữ 14 ngày

# Thử phục hồi thật rồi đối chiếu — làm hằng tuần
deployments/verify-backup-restore.sh <thư_mục_web> <file.sql.gz>

# Phục hồi một khách thuê bao
deployments/restore-tenant.sh <mã_khách> <file.sql.gz>
```

⚠️ Lệnh phục hồi **xoá và tạo lại** cơ sở dữ liệu đích. **Luôn sao lưu mới ngay trước khi phục hồi**
để còn đường lùi.

Sao lưu tính là thành công chỉ khi: số cơ sở dữ liệu đã sao lưu **bằng đúng** số khách thuê bao khai
báo ở cơ sở trung tâm, cộng một cơ sở chính. Thiếu một cái là cả lần sao lưu bị đánh hỏng — đừng bỏ qua.

**Trước mọi lần nhập dữ liệu lớn, luôn sao lưu trước** (xem skill `bos-data-import` — import không có
nút hoàn tác).

## Triển khai an toàn

```bash
./deployments/deploy.sh <mã_khách>
```

Những điều đã học được bằng sự cố thật, đừng phá:

- **Xoá bộ nhớ đệm TRƯỚC khi chạy nâng cấp cơ sở dữ liệu.** Làm ngược lại thì hệ thống không nhìn
  thấy bảng mới của phân hệ mới, và bảng sẽ bị tạo thiếu mà không báo.
- Có **cổng kiểm tra trước khi triển khai** chạy tự động (rà bảo mật phân hệ, kiểm cú pháp, thử
  đường dẫn, chạy kiểm thử). **Bị chặn thì sửa, không bỏ qua** trừ trường hợp khẩn cấp có chủ đích
  và có người chịu trách nhiệm.
- Với nền tảng cài riêng, phân hệ quản lý thuê bao SaaS phải **tắt tự động** — không để lộ màn hình
  quản trị thuê bao cho khách cài riêng.

Sau mỗi lần triển khai: chạy quét sức khoẻ toàn hệ thống, và kiểm tra bằng tay vài luồng chính
(bán một đơn, in một hoá đơn, xem một báo cáo).

## Bật / tắt phân hệ

Mỗi khách chỉ bật phân hệ đã mua. Trạng thái nằm ở `modules_statuses.json` trên máy chủ và được
khai báo lại trong `deployments/<khách>/config.json`.

- Màn hình thiếu phân hệ tương ứng sẽ **tự ẩn** — không để nút chết. Vậy nên "chức năng biến mất"
  thường là phân hệ chưa bật, không phải lỗi.
- **Phân hệ "ma"** = được khai là đang bật nhưng thư mục mã nguồn không còn → gây lỗi 500 rải rác.
  Quét sức khoẻ hằng tuần chính là để bắt loại này.
- Bật/tắt phân hệ là thao tác **có kiểm soát**: ghi lại ai yêu cầu, ngày nào, vì sao.

## Xử lý sự cố hạ tầng

| Hiện tượng | Nhìn vào đâu trước |
|---|---|
| Cả trang không vào được | Máy chủ web và PHP còn sống không, đĩa còn chỗ không |
| Chậm toàn hệ thống | Cơ sở dữ liệu (câu truy vấn treo), hoặc hàng đợi dồn ứ |
| Chậm một màn hình | Màn đó thường là báo cáo — hỏi kỳ dữ liệu khách đang lọc |
| Lỗi 500 rải rác sau khi triển khai | Bộ nhớ đệm cấu hình/đường dẫn cũ, hoặc phân hệ ma |
| Đăng nhập bị vòng lặp | Trùng tên đường dẫn đăng nhập giữa cấu hình chung và cấu hình thuê bao |
| Mọi việc nền ngừng chảy | Hàng đợi chết, hoặc khoá chồng lượt còn treo |

## Nhật ký vận hành

Ghi lại mọi thay đổi có tác động: triển khai, bật/tắt phân hệ, phục hồi dữ liệu, nhập liệu lớn,
đổi cấu hình tích hợp. Mỗi dòng: **ngày giờ · khách nào · ai làm · làm gì · vì sao · kết quả**.

Khi có sự cố, câu hỏi đầu tiên luôn là *"gần đây có gì thay đổi không"* — không có nhật ký thì
không trả lời được, và thời gian tìm nguyên nhân tăng gấp nhiều lần.

## Quản lý thông tin đăng nhập máy chủ

Thông tin đăng nhập máy chủ và cơ sở dữ liệu **không được để dạng chữ thường trong kho mã**, kể cả
kho riêng tư. Lý do: ai đọc được kho là có quyền quản trị toàn bộ máy chủ khách hàng, và xoá khỏi
file hiện tại **không đủ** — lịch sử Git vẫn giữ nguyên bản cũ.

Nguyên tắc áp dụng:

- Đăng nhập máy chủ bằng **khoá SSH**, không dùng mật khẩu.
- Thông tin nhạy cảm để ở **biến môi trường** hoặc kho bí mật ngoài kho mã.
- Nếu phát hiện đã lỡ đưa vào kho: **đổi toàn bộ thông tin đăng nhập trước** (bản cũ coi như đã lộ),
  rồi mới dọn lịch sử Git — làm ngược thứ tự là vô nghĩa.
- Chỉ người phụ trách kỹ thuật có quyền truy cập máy chủ. Vận hành và hỗ trợ **không tự SSH**.
