# BOS Skills — Sổ tay vận hành cho AI

Sáu cuốn sổ tay nghiệp vụ viết sẵn cho trợ lý AI, dùng cho công việc **triển khai · vận hành ·
hỗ trợ khách hàng** trên nền tảng BOS.

Hỏi AI bằng tiếng Việt như hỏi đồng nghiệp — nó tự mở đúng cuốn và trả lời theo quy trình đã chốt,
thay vì trả lời chung chung.

**Không cần biết lập trình để dùng.**

---

## Bộ skill gồm gì

| Skill | Trả lời câu hỏi gì | Ai dùng nhiều nhất |
|---|---|---|
| [`bos-nhan-vien-moi`](skills/bos-nhan-vien-moi/) | Người mới học gì trước, khi nào được tự nhận khách | Người mới + quản lý |
| [`bos-business-logic`](skills/bos-business-logic/) | Hệ thống hành xử như vậy vì sao, số liệu từ đâu ra | Tất cả |
| [`bos-data-import`](skills/bos-data-import/) | Xin dữ liệu gì ở khách, kiểm đủ thiếu, làm sạch, sửa lỗi import | Triển khai |
| [`bos-golive`](skills/bos-golive/) | Đưa khách lên chạy thật theo thứ tự nào | Triển khai |
| [`bos-helpdesk`](skills/bos-helpdesk/) | Khách báo lỗi thì phân loại và xử lý ra sao | Hỗ trợ |
| [`bos-operations`](skills/bos-operations/) | Hệ thống chạy nền có gì, sao lưu phục hồi thế nào | Vận hành + kỹ thuật |

---

## Cài đặt

### Bước 1 — Cài Claude Code

Xem hướng dẫn tại [claude.com/claude-code](https://claude.com/claude-code).
Cài xong mở Terminal gõ `claude`, thấy chạy là được.

### Bước 2 — Tải và cài bộ skill

```bash
git clone https://github.com/nguyenduchoai/BOS-Skills.git ~/BOS-Skills
cd ~/BOS-Skills
./install.sh
```

### Bước 3 — Kiểm tra

```bash
ls ~/.claude/skills | grep bos-
```

Thấy đủ 6 dòng `bos-*` là xong. Mở lại Claude Code để nó nạp skill mới.

> **Windows** — dùng Git Bash hoặc WSL để chạy `install.sh`. Hoặc chép tay:
> copy các thư mục trong `skills/` vào `%USERPROFILE%\.claude\skills\`.

---

## Dùng như thế nào

Mở Claude Code trong thư mục làm việc rồi hỏi bằng tiếng Việt. Skill tự kích hoạt theo nội dung câu hỏi.

| Bạn gõ | Skill tự mở | Bạn nhận được |
|---|---|---|
| *"Khách gửi file tồn kho rồi, kiểm giúp em xem đủ chưa"* | `bos-data-import` | Quy trình nghiệm thu 15 phút, danh sách phải kiểm |
| *"Soạn giúp em thư xin dữ liệu cho khách mới"* | `bos-data-import` | Thư hoàn chỉnh, 6 loại bắt buộc + 4 loại nên có |
| *"File báo lỗi GIÁ VỐN không phải là số"* | `bos-data-import` | Nguyên nhân + cách sửa cụ thể |
| *"Khách hỏi sao chuyển khoản rồi mà đơn chưa xác nhận"* | `bos-helpdesk` | 5 nguyên nhân theo thứ tự kiểm, và cách trả lời khách |
| *"Sắp triển khai khách mới, cần chuẩn bị gì"* | `bos-golive` | 6 giai đoạn, bảng nghiệm thu 13 mục |
| *"Vì sao đơn nháp không trừ tồn kho"* | `bos-business-logic` | Giải thích bằng ngôn ngữ nghiệp vụ |
| *"Tuần này em cần học gì"* | `bos-nhan-vien-moi` | Lộ trình theo tuần + bài kiểm tra |

**Gọi thẳng một skill:** gõ `/bos-data-import`. Dùng khi biết chắc cần cuốn nào, hoặc khi AI mở nhầm.

### Hỏi thế nào cho ra kết quả tốt

| Nên | Không nên |
|---|---|
| *"Khách A gửi file công nợ 420 dòng, kiểm giúp em"* | *"kiểm file này"* |
| *"Đơn #1234 khách chuyển 5 triệu lúc 9h sáng nay mà chưa xác nhận"* | *"lỗi thanh toán"* |
| Dán nguyên văn thông báo lỗi | Mô tả lại lỗi bằng trí nhớ |
| Nói rõ khách nào, màn hình nào, lúc nào | Hỏi trống không |

**Kéo thả file vào cửa sổ chat** để AI đọc trực tiếp — nhanh hơn tả lại nội dung file.

---

## Bài tập cho người mới

Thư mục [`bai-tap/`](bai-tap/) có một bộ 4 file dữ liệu khách gửi tới, **có lỗi cài sẵn** — dùng cho
bài kiểm tra cuối tuần 2 trong lộ trình `bos-nhan-vien-moi`.

Người học nhận 4 file CSV và đề bài; người kèm giữ đáp án. Chấm đạt khi tìm được ≥ 80% lỗi **và**
bắt được cả 3 lỗi bắt buộc — ba lỗi tốn tiền nhất khi lọt xuống hệ thống thật.

---

## Ba điều phải nhớ khi dùng AI trong công việc

1. **AI không thay bạn chịu trách nhiệm.** Nó gợi ý, bạn kiểm và quyết. Trước khi ghi sổ dữ liệu
   khách, luôn tự soát lại.
2. **Không dán thông tin nhạy cảm vào chat** — mật khẩu, khoá API, thông tin cá nhân khách hàng.
   Cần kiểm file khách thì che cột nhạy cảm trước.
3. **AI nói sai vẫn nghe rất thuyết phục.** Số liệu, quy tắc nghiệp vụ, con số tiền — luôn đối chiếu
   lại với hệ thống thật hoặc hỏi người cũ.

---

## Cập nhật

```bash
cd ~/BOS-Skills && git pull && ./install.sh
```

Script cài **chỉ ghi đè 6 thư mục `bos-*`**, không đụng tới skill khác bạn đang có.

## Không thấy skill chạy thì làm gì

| Hiện tượng | Cách xử lý |
|---|---|
| AI trả lời chung chung, không theo quy trình | Gọi thẳng bằng `/bos-data-import` |
| `ls ~/.claude/skills` không thấy `bos-*` | Chạy lại `./install.sh` |
| Vừa cài xong vẫn chưa nhận | Thoát Claude Code và mở lại — skill nạp lúc khởi động |
| AI mở nhầm skill khác | Nói rõ hơn, hoặc gọi thẳng bằng dấu `/` |

---

## Đóng góp

Gặp ca mới chưa có trong tài liệu — một lỗi import lạ, một câu hỏi khách chưa ai trả lời được —
thì mở issue hoặc pull request. Ghi ngắn gọn:

- **Tình huống** — làm gì, gặp gì
- **Nguyên nhân thật sự** — sau khi đã xử lý xong
- **Cách xử lý đúng**

Mỗi ca được bổ sung là người sau đỡ mất một buổi đi tìm.

Khi viết thêm: **không đưa tên khách hàng thật, thông tin đăng nhập, địa chỉ máy chủ hay số liệu
thật của khách** vào tài liệu.
