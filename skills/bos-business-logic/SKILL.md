---
name: bos-business-logic
description: >
  Logic nghiệp vụ của nền tảng BOS giải thích cho người vận hành và hỗ trợ khách — nguyên tắc một
  nguồn dữ liệu duy nhất, vòng đời chứng từ (nháp/hoàn tất và chưa trả/đã trả), dòng chảy bán hàng →
  kho → kế toán, vì sao trạng thái "đã thanh toán" chỉ được đặt bởi webhook đã xác thực, công nợ
  bốn chiều, đối soát tiền và COD và tiền sàn, nhiều chi nhánh và nhiều pháp nhân, cách đọc lệch số
  giữa các báo cáo. USE WHEN người dùng nói: logic vận hành BOS, nghiệp vụ BOS, luồng chứng từ,
  vì sao số liệu lệch, đối soát, công nợ, giá vốn, tồn kho sai, giải thích cho khách, đào tạo nhân viên.
user-invocable: true
when_to_use: "Dùng khi cần hiểu hoặc giải thích một hành vi nghiệp vụ của BOS: chứng từ chảy đi đâu, số liệu từ đâu ra, vì sao hai báo cáo lệch nhau, vì sao hệ thống từ chối một thao tác."
category: operations
keywords: [bos, nghiep-vu, chung-tu, ton-kho, gia-von, cong-no, doi-soat, ssot, da-chi-nhanh, bao-cao]
metadata:
  author: Bizino
  version: "1.0.0"
  language: vi
---

# BOS · Logic vận hành nghiệp vụ

Tài liệu này giải thích **vì sao hệ thống hành xử như vậy**, dành cho người vận hành và hỗ trợ khách —
không phải tài liệu lập trình. Quy tắc viết mã tương ứng nằm ở skill `bos-new-ssot-standard` trong repo BOS.

## Nguyên tắc gốc: một dữ kiện chỉ có một nơi làm chủ

Toàn bộ thiết kế BOS đứng trên một câu: **một dữ kiện chỉ được làm chủ ở đúng một nơi.** Phân hệ nào
sở hữu dữ liệu nào thì nghiệp vụ của dữ liệu đó nằm ở phân hệ ấy; màn hình khác chỉ **đọc và dẫn sang**,
không chép lại.

Hệ quả khi hỗ trợ khách:

- Khách hàng chỉ có **một hồ sơ duy nhất** dù đến từ quầy, Zalo MiniApp, website hay sàn. Số điện thoại
  được chuẩn hoá về một dạng trước khi so trùng — nên `+84901…` và `0901…` là **cùng một người**.
  Nếu thấy hai hồ sơ trùng, đó là dữ liệu bẩn cần gộp, không phải thiết kế.
- Giá, thuế, chiết khấu được tính ở **một chỗ duy nhất**. Nên nếu tổng tiền trên MiniApp khác trên quầy
  thì nguyên nhân là **dữ liệu đầu vào khác** (bảng giá, chương trình khuyến mãi, chi nhánh), không phải
  hai công thức khác nhau.
- Tin nhắn/thông báo đi qua một cổng chung — nên trạng thái *khách đã từ chối nhận tin* được tôn trọng
  ở mọi kênh. Khách "không nhận được tin" đôi khi là do chính họ đã tắt nhận tin.

Khi khách hỏi "sao chỗ này sửa mà chỗ kia không đổi": tìm xem **nơi nào là chủ** của dữ kiện đó, sửa ở đấy.

## Vòng đời chứng từ

Mỗi chứng từ có **hai trục trạng thái độc lập** — hay bị nhầm là một:

| Trục | Giá trị | Ý nghĩa |
|---|---|---|
| Trạng thái chứng từ | `nháp` → `hoàn tất` | Với đơn mua còn có `đã đặt` → `đã nhận` |
| Trạng thái thanh toán | `chưa trả` → `đã trả` | Độc lập hoàn toàn với trục trên |

Quy tắc quan trọng: **chứng từ nháp không tác động tồn kho và sổ sách.** Chỉ khi chuyển sang *hoàn tất*
thì tồn mới trừ, công nợ mới ghi. Khách báo "đã bán rồi mà tồn không giảm" thì việc đầu tiên là kiểm tra
đơn còn ở trạng thái nháp không.

Và: **đơn hoàn tất nhưng chưa thanh toán vẫn trừ tồn kho** — vì hàng đã giao. Đây là chỗ khách hay nhầm
giữa "doanh thu" và "tiền thực thu".

## Dòng chảy bán hàng → kho → kế toán

```
Đơn bán (hoàn tất)
   ├── Kho:      trừ tồn theo từng chi nhánh, ghi nhận giá vốn
   ├── Công nợ:  nếu chưa thu đủ → ghi nợ phải thu cho khách
   ├── Kế toán:  sinh bút toán doanh thu / giá vốn
   └── Sau đó:   thu tiền → giảm công nợ, tăng quỹ/ngân hàng
```

Điểm mấu chốt khi hỗ trợ: **tiền và hàng là hai dòng riêng.** Một đơn có thể:
giao hàng nhưng chưa thu tiền (nợ), thu tiền trước nhưng chưa giao (tạm ứng của khách),
hoặc giao một phần thu một phần. Trả lời khách phải tách bạch hai dòng này, đừng gộp làm một.

Đơn mua chảy ngược lại: nhập kho làm **tăng tồn và hình thành giá vốn**, đồng thời ghi nợ phải trả
nhà cung cấp nếu chưa thanh toán.

## Vì sao hệ thống không cho tự bấm "đã thanh toán"

Đây là câu hỏi khách hỏi nhiều nhất, và câu trả lời là **cố ý thiết kế như vậy**:

> Trạng thái *đã thanh toán* chỉ được đặt bởi (a) tín hiệu từ ngân hàng/cổng thanh toán **đã xác thực
> chữ ký**, hoặc (b) quản trị viên xác nhận trên màn quản trị.

Khách hàng cuối, nhân viên cầm điện thoại, hay màn hình gọi món **không được** tự đánh dấu đã trả tiền.
Lý do: nếu cho phép, bất kỳ ai biết đường dẫn đều có thể tự tuyên bố "tôi đã trả" và lấy hàng đi.

Các chốt chặn đi kèm — hiểu để giải thích cho khách, đừng coi là lỗi:

- **Số tiền lệch thì từ chối** đánh dấu đã trả. Khách chuyển thiếu 1.000đ là đơn đứng nguyên.
- **Chống trùng**: cùng một tín hiệu báo có tiền gửi lại nhiều lần chỉ được xử lý **một lần**.
- **Khoá dòng khi ghi**: hai tín hiệu đến cùng lúc không thể cùng ghi nhận thành hai lần thu tiền.
- Mã QR không gắn với cổng thanh toán thật thì hệ thống báo rõ là **cần thu ngân xác nhận**, chứ không
  tự cho là đã trả.

Khi tiền thật đã về mà đơn chưa tự cập nhật: quản trị viên xác nhận tay, **rồi báo kỹ thuật tìm nguyên
nhân** — đừng dừng ở việc xác nhận tay, vì lần sau sẽ lặp lại.

## Công nợ có bốn chiều

Công nợ luôn hai chiều, mỗi chiều hai trạng thái:

| Thực tế | Kế toán | Trong BOS |
|---|---|---|
| Khách còn nợ mình | TK 131 dư Nợ | Nợ phải thu |
| Khách trả trước cho mình | TK 131 dư Có | **Tạm ứng của khách** — cấn trừ khi bán |
| Mình còn nợ nhà cung cấp | TK 331 dư Có | Nợ phải trả |
| Mình trả trước cho NCC | TK 331 dư Nợ | **Tiền đã ứng cho NCC** — cấn trừ khi nhập hàng |

**Trả trước không phải là nợ.** Ghi nhầm khoản trả trước vào nợ sẽ làm sai cả hai báo cáo công nợ,
và số liệu sẽ lệch mãi cho đến khi tìm ra. Cách nhập: xem skill `bos-data-import`.

Hai quy tắc hệ thống tự áp:
- Mỗi đối tượng chỉ nhận **nợ đầu kỳ một lần** — chống nhân đôi công nợ.
- Đối tượng vừa là khách vừa là nhà cung cấp thì được **tách hồ sơ**, cố ý **không tự bù trừ**
  hai tài khoản. Muốn bù trừ phải làm bút toán riêng có người duyệt.

Sổ chi tiết theo đối tượng và số dư tổng trên sổ cái là **hai nơi nhập khác nhau** — phải nhập cả hai
và tổng phải khớp. Lệch giữa hai chỗ là dấu hiệu nhập thiếu một bên.

## Đối soát — ba loại, đừng lẫn

| Loại | Đối soát cái gì | Điều hay sai |
|---|---|---|
| **Tiền chuyển khoản** | Tiền vào tài khoản ngân hàng ↔ đơn hàng | Khách chuyển sai nội dung, chuyển gộp nhiều đơn, chuyển thiếu |
| **COD** (giao hàng thu hộ) | Tiền hãng vận chuyển trả về ↔ đơn đã giao | Hãng trả gộp theo đợt và **đã trừ phí** — phải tách phí trước khi khớp |
| **Tiền sàn TMĐT** | Bảng đối soát của sàn ↔ đơn trên hệ thống | Sàn trừ nhiều loại phí; có khoản **hoàn lại phí** mang dấu ngược |

Với đối soát sàn: dòng phí **lệch dấu** so với nhóm là khoản sàn **hoàn lại**. Nếu ai đó "sửa cho đẹp"
bằng cách đổi dấu âm thành dương thì tổng phí phồng lên đúng gấp đôi khoản hoàn — và đối soát lệch
đúng bằng chừng ấy. Đừng sửa dấu trong file đối soát.

Cột phí lạ mà hệ thống chưa biết vẫn được **giữ lại và đánh dấu chưa nhận diện**, không bị bỏ im lặng.
Sau mỗi đợt đối soát nên xem danh sách này để bổ sung.

## Nhiều chi nhánh, nhiều pháp nhân

- **Chi nhánh**: tồn kho, giá bán và báo cáo đều tách theo chi nhánh. Người dùng chỉ thấy chi nhánh
  được gán. "Mất hàng" thường là **hàng nằm ở chi nhánh khác**, không phải mất.
- Doanh nghiệp nhiều chi nhánh thì mọi nhập liệu đều **bắt buộc chỉ rõ chi nhánh**.
- **Nhiều pháp nhân**: mỗi pháp nhân có sổ sách riêng. Giao dịch giữa hai pháp nhân trong cùng nhóm là
  **giao dịch nội bộ** — phải loại trừ khi hợp nhất báo cáo nhóm, không được cộng dồn thành doanh thu.
- Với nền tảng cho thuê, **mỗi khách hàng nằm ở một cơ sở dữ liệu riêng** — dữ liệu không thể nhìn
  chéo giữa các khách. Khách hỏi "sao không thấy dữ liệu bên kia" thì đó là ranh giới cố ý.

## Đọc lệch số giữa các báo cáo

Trước khi kết luận phần mềm sai, xác định 5 điều — phần lớn "lỗi sai số" tan biến ở bước này:

1. **Kỳ nào** — và tính theo *ngày chứng từ* hay *ngày ghi sổ*.
2. **Chi nhánh nào** — báo cáo tổng và báo cáo chi nhánh không so được với nhau.
3. **Pháp nhân nào** — nếu khách có nhiều pháp nhân.
4. **Có gồm đơn nháp / đơn huỷ / đơn trả không.**
5. **Doanh thu hay tiền thực thu** — hai con số khác nhau về bản chất, và đây là nhầm lẫn phổ biến nhất.

Lệch có thật thì truy ngược về **chứng từ gốc**: tìm chứng từ chênh lệch, xem lịch sử sửa của nó.
Đừng bao giờ sửa thẳng số liệu tổng hợp cho khớp — số sẽ khớp hôm nay và sai lại vào ngày mai.

## Quyền hạn

Người dùng thấy gì phụ thuộc **vai trò + chi nhánh được gán + pháp nhân đang chọn**. Khi khách báo
"không thấy dữ liệu" hoặc "không bấm được nút", kiểm tra ba thứ này trước khi nghi ngờ lỗi hệ thống.

Các thao tác chạm vào tiền (xác nhận thanh toán, sửa giá, duyệt chi) là **quyền riêng**, cố ý tách
khỏi quyền thao tác thường. Cấp thêm quyền cho ai thì phải có người yêu cầu và ghi vào nhật ký.
