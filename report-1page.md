# Report 1 page - Lab 4 DES / TripleDES

## Mục tiêu

Mục tiêu của bài lab là hoàn thiện chương trình DES từ mã khung ban đầu để:

- nhận input từ bàn phím theo contract chuẩn (stdin),
- hỗ trợ mã hóa/giải mã DES,
- hỗ trợ TripleDES (EDE) cho 64-bit block,
- xử lý plaintext dài nhiều block với zero padding,
- và xây dựng bộ test gồm cả positive/negative cases.

## Cách làm / Method

Từ code DES mẫu (chỉ encrypt 1 block hard-code), em mở rộng thành chương trình có 4 mode:

1. **Mode 1 - DES encrypt**: nhận plaintext nhị phân + key 64-bit, hỗ trợ multi-block.
2. **Mode 2 - DES decrypt**: nhận ciphertext nhị phân + key 64-bit, giải mã bằng round keys đảo ngược.
3. **Mode 3 - TripleDES encrypt**: thực hiện E(K3, D(K2, E(K1, P))).
4. **Mode 4 - TripleDES decrypt**: thực hiện ngược lại để khôi phục plaintext.

Các thành phần chính:

- `KeyGenerator`: sinh 16 round keys từ key 64-bit.
- `DES::run_block`: chạy 16 vòng Feistel cho một block 64-bit (encrypt/decrypt).
- `split_and_zero_pad`: chia dữ liệu thành block 64-bit và pad `0` block cuối nếu thiếu.
- `run_des_stream`: chạy DES trên toàn bộ stream nhiều block.

Ngoài ra có kiểm tra input hợp lệ (chuỗi nhị phân, độ dài key) để tránh chạy sai format.

## Kết quả / Result

Kết quả đạt được:

- DES sample vector cho ciphertext đúng với giá trị mong đợi.
- Encrypt/Decrypt round-trip khôi phục đúng plaintext.
- Multi-block + zero padding cho output đúng theo cách mã hóa từng block độc lập rồi nối lại.
- Negative test tamper: lật bit ciphertext làm giải mã không còn trùng plaintext gốc.
- Negative test wrong-key: giải mã với khóa sai không khôi phục plaintext.

Tổng cộng đã hoàn thiện 5 test bắt buộc trong thư mục `tests/` theo yêu cầu lab.

## Kết luận / Conclusion

Qua bài này em hiểu rõ hơn:

- cơ chế Feistel của DES,
- cách đảo ngược round keys để giải mã,
- cách ghép DES thành TripleDES theo EDE,
- và tầm quan trọng của test tự động cho cả ca đúng/sai.

Hạn chế hiện tại:

- padding đang dùng zero padding nên chưa thể tự loại phần pad khi giải mã.
- chưa có chế độ vận hành block cipher mode nâng cao (CBC/CFB/OFB/CTR).

Hướng mở rộng:

- bổ sung chuẩn padding như PKCS#7,
- thêm IV + CBC mode,
- đọc/ghi dữ liệu từ file thay vì chỉ stdin.
