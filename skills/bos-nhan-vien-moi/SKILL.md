---
name: bos-nhan-vien-moi
description: >
  Lộ trình 30 ngày đầu cho nhân viên mới của Bizino làm mảng triển khai — vận hành — hỗ trợ khách
  trên nền tảng BOS. Chia theo tuần: học gì, làm gì, ngồi cùng ai, được tự làm việc gì và chưa được
  làm việc gì; kèm bài kiểm tra cuối mỗi tuần, danh sách quyền truy cập cần cấp, và tiêu chí để
  quản lý quyết định cho tự nhận khách. USE WHEN người dùng nói: nhân viên mới, onboarding nhân sự,
  đào tạo người mới, lộ trình 30 ngày, người mới học gì trước, khi nào cho tự nhận khách,
  kèm cặp nhân viên, checklist nhận việc.
user-invocable: true
when_to_use: "Dùng khi có nhân viên mới vào mảng triển khai/vận hành/hỗ trợ BOS, cần lộ trình học theo thứ tự, hoặc khi quản lý cần đánh giá người mới đã đủ tự làm chưa."
category: operations
keywords: [bizino, nhan-vien-moi, onboarding, dao-tao, lo-trinh, kem-cap, bos]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# Bizino · Lộ trình 30 ngày cho nhân viên mới

Dành cho vị trí **triển khai / vận hành / hỗ trợ khách hàng** trên nền tảng BOS.

Nguyên tắc xuyên suốt: **không cho người mới chạm vào dữ liệu thật của khách trong 2 tuần đầu.**
Sai một lần trên dữ liệu thật đắt hơn cả tháng lương — nhập sai tồn đầu kỳ thì giá vốn sai mãi mãi.

## Bộ skill dùng làm giáo trình

| Skill | Học vào tuần | Trả lời câu hỏi gì |
|---|---|---|
| `bos-business-logic` | 1 | Hệ thống hành xử như vậy vì sao |
| `bos-data-import` | 2 | Xin dữ liệu gì, kiểm thế nào, làm sạch ra sao |
| `bos-golive` | 3 | Đưa khách lên chạy thật theo thứ tự nào |
| `bos-helpdesk` | 4 | Khách báo lỗi thì làm gì |
| `bos-operations` | tham khảo | Hệ thống chạy nền có những gì |

Cách học một skill: **đọc hết một lượt → làm bài tập của tuần → đọc lại phần liên quan khi vướng.**
Không thuộc lòng, chỉ cần biết *có cái đó* và *tra ở đâu*.

## Tuần 1 — Hiểu nghiệp vụ, chưa đụng hệ thống thật

**Mục tiêu:** nói được BOS làm gì cho một doanh nghiệp, bằng ngôn ngữ của chủ doanh nghiệp.

| Ngày | Việc |
|---|---|
| 1 | Nhận tài khoản, đọc `README` của BOS. Hiểu: một lõi, nhiều phân hệ, mỗi khách bật cái mình mua |
| 2 | Đọc `bos-business-logic` phần *nguyên tắc gốc* và *vòng đời chứng từ* |
| 3 | Được cấp **tài khoản trên hệ thống demo**. Tự tay: tạo 5 sản phẩm, bán 3 đơn, xem tồn kho giảm |
| 4 | Trên demo: bán một đơn **chưa thu tiền** → xem công nợ. Thu tiền → xem công nợ giảm |
| 5 | Đọc `bos-business-logic` phần *công nợ 4 chiều* và *đọc lệch số*. Ngồi nghe 3 cuộc gọi hỗ trợ khách |

**Bài kiểm tra cuối tuần 1** — trả lời miệng, không nhìn tài liệu:

1. Đơn ở trạng thái nháp có trừ tồn kho không? Vì sao?
2. Đơn đã hoàn tất nhưng khách chưa trả tiền thì tồn kho có giảm không?
3. Khách chuyển khoản rồi mà đơn vẫn "chưa thanh toán" — kể 3 nguyên nhân có thể.
4. "Khách trả trước tiền hàng" ghi vào nợ đầu kỳ hay tạm ứng? Vì sao quan trọng?
5. Doanh thu và tiền thực thu khác nhau chỗ nào?

Chưa trả lời được thì **học lại tuần 1**, đừng sang tuần 2. Đây là nền của mọi thứ phía sau.

## Tuần 2 — Dữ liệu: xin, kiểm, làm sạch

**Mục tiêu:** cầm file khách gửi và kết luận được *nhận đủ / thiếu gì* trong 15 phút.

| Ngày | Việc |
|---|---|
| 6 | Đọc `bos-data-import` — cả SKILL.md và `references/ban-do-cot.md` |
| 7 | Đọc `references/yeu-cau-va-nghiem-thu-du-lieu.md`. Tự soạn thư xin dữ liệu cho một khách giả định |
| 8 | **Bài tập file bẩn**: quản lý đưa 3 file có lỗi cài sẵn → tìm ra hết lỗi, viết thư báo khách |
| 9 | Trên demo: nhập trọn bộ danh mục + tồn đầu kỳ + khách hàng. Cố ý nhập sai một lần để thấy lỗi thật |
| 10 | Đọc `references/loi-thuong-gap.md`. Ngồi cùng người cũ khi họ làm sạch dữ liệu khách thật (**chỉ xem**) |

**Bài kiểm tra cuối tuần 2** — làm thật, có chấm:

- Đưa một bộ file khách (đã ẩn thông tin) → nghiệm thu và viết kết luận: nhận đủ / thiếu phụ / trả lại,
  kèm **danh sách thiếu cụ thể** và thư gửi khách.
- Chấm đạt khi: tìm đúng ≥ 80% lỗi cài sẵn, **và** thư gửi khách nói rõ thiếu gì chứ không nói chung chung.

Ba lỗi bắt buộc phải nhận ra, vì đây là ba lỗi tốn tiền nhất:
1. Tên chi nhánh giữa các file không khớp nhau.
2. Mã hàng trong file tồn kho không có trong danh mục hàng hoá.
3. Số trong file tồn kho ghi kiểu `1.500.000` (màn tồn đầu kỳ chỉ nhận số thuần).

## Tuần 3 — Triển khai: đi theo người cũ

**Mục tiêu:** biết trình tự một dự án triển khai và vì sao không được đảo thứ tự.

| Ngày | Việc |
|---|---|
| 11 | Đọc `bos-golive` toàn bộ |
| 12 | Ngồi cùng buổi khảo sát khách thật — **ghi biên bản**, đây là việc đầu tiên được giao thật |
| 13 | Tự dựng nền cho một khách giả định trên demo: chi nhánh, đơn vị tính, thuế suất, vai trò |
| 14 | Nhập đầu kỳ trên demo theo đúng thứ tự, tự đối chiếu tổng sau mỗi loại |
| 15 | Đi cùng buổi đào tạo khách. Quan sát: người dùng vướng ở đâu, hỏi câu gì nhiều nhất |

**Bài kiểm tra cuối tuần 3:**

- Trình bày 5 phút cho quản lý: *"kế hoạch triển khai khách X"* — từ khảo sát đến nghiệm thu.
- Câu hỏi vấn đáp: khách hối go-live trong khi chưa có tồn đầu kỳ, bạn nói gì với khách?
  (Đáp án đúng: dùng bảng đủ/thiếu, chỉ rõ 3 dòng đầu là điều kiện cần tuyệt đối, không nhận đại.)

## Tuần 4 — Hỗ trợ: bắt đầu nhận việc thật có giám sát

**Mục tiêu:** xử lý được ticket P3–P4 một mình, nhận biết đúng P1–P2 để chuyển ngay.

| Ngày | Việc |
|---|---|
| 16 | Đọc `bos-helpdesk` toàn bộ |
| 17 | Đọc lại 20 ticket cũ đã đóng — tự phân loại mức độ, so với cách người cũ đã phân |
| 18 | **Nhận ticket P4 đầu tiên** (hỏi cách dùng) — người kèm duyệt câu trả lời trước khi gửi khách |
| 19 | Nhận ticket P3 — vẫn duyệt trước khi gửi |
| 20 | Ngồi cùng một ca P1/P2 thật nếu có. Đọc `bos-operations` để biết cái gì chạy nền |

**Bài kiểm tra cuối tuần 4:**

Đưa 5 tình huống, yêu cầu phân loại mức độ + nói hướng xử lý + nói rõ *tự làm hay chuyển kỹ thuật*:

| Tình huống | Đáp án |
|---|---|
| Khách hỏi cách in lại hoá đơn | P4, tự làm |
| Một nhân viên không thấy menu kho | P3, kiểm phân quyền + chi nhánh trước, tự làm được |
| Đơn từ Shopee 2 ngày nay không về | P2, kiểm token/webhook/queue rồi chuyển kỹ thuật |
| Tiền khách chuyển về mà đơn không tự xác nhận | P2, quản trị xác nhận tay **rồi vẫn phải** báo kỹ thuật |
| Cả hệ thống không vào được | P1, báo kỹ thuật **ngay**, không tự mò |

## Ngày 30 — Quyết định cho tự nhận khách

Quản lý tick đủ mới cho tự nhận khách:

- [ ] Qua cả 4 bài kiểm tra tuần
- [ ] Đã nghiệm thu ít nhất **2 bộ file khách thật** đúng (có người cũ soát lại)
- [ ] Đã xử lý ít nhất **10 ticket** P3–P4 mà không phải sửa lại câu trả lời
- [ ] Đã đi trọn **1 dự án triển khai** cùng người cũ, từ khảo sát đến nghiệm thu
- [ ] Biết **khi nào phải dừng lại và hỏi** — tiêu chí quan trọng nhất

Chưa đủ thì kéo dài thời gian kèm, **đừng thả sớm**. Một dự án hỏng vì thả sớm tốn nhiều hơn
một tháng kèm thêm.

## Quyền truy cập cấp theo tuần

Cấp dần, không cấp hết ngay ngày đầu:

| Tuần | Được cấp |
|---|---|
| 1 | Tài khoản demo (toàn quyền trên demo), quyền đọc tài liệu nội bộ |
| 2 | Quyền xem hệ thống khách (**chỉ đọc**), quyền nhận file từ khách |
| 3 | Quyền nhập liệu trên hệ thống khách đang triển khai (**chưa go-live**) |
| 4 | Quyền vào hệ thống ticket, trả lời khách qua kênh chính thức |
| Sau ngày 30 | Quyền thao tác trên hệ thống khách **đã chạy thật**, theo phạm vi được giao |

**Không bao giờ cấp cho người mới:** truy cập máy chủ (SSH), quyền chạy lệnh trên máy chủ, quyền
xoá dữ liệu, quyền phục hồi dữ liệu. Những việc này thuộc kỹ thuật, kể cả sau 30 ngày.

## Luật bất di bất dịch cho người mới

Bốn điều này, vi phạm là dừng việc để nói chuyện lại:

1. **Không chắc thì hỏi.** Hỏi mất 5 phút. Đoán sai trên dữ liệu khách mất vài ngày sửa,
   và đôi khi không sửa được.
2. **Không sao lưu thì không nhập.** Nhập liệu không có nút hoàn tác.
3. **Không hứa với khách điều mình chưa xác nhận được.** Nói "em kiểm tra rồi báo lại anh/chị
   trước 4h chiều" luôn tốt hơn một lời hứa sai.
4. **Không tự nới lỏng bảo mật để cho chạy tạm** — nhất là kiểm tra chữ ký webhook và quyền xác
   nhận thanh toán. Khách hối cũng không.

## Người kèm cần làm gì

- Mỗi ngày cuối tuần 1–2: dành **15 phút** hỏi *"hôm nay vướng gì"*. Người mới thường không tự khai.
- Duyệt **toàn bộ** câu trả lời khách trong tuần 4, sửa thì giải thích vì sao sửa.
- Giao bài tập trên **dữ liệu đã ẩn thông tin**, không dùng dữ liệu khách thật để tập.
- Khi người mới sai: hỏi *"lúc đó bạn nghĩ gì"* trước khi chỉ ra cái sai — để biết lỗ hổng thật
  nằm ở hiểu biết nào.
