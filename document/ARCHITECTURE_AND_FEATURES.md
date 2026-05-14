# TÀI LIỆU MÔ TẢ HỆ THỐNG

Tài liệu này mô tả kiến trúc, công nghệ và các tính năng nghiệp vụ cốt lõi của **Hệ thống Đăng ký Môn học (Course Registration System)**.

---

## 1. KIẾN TRÚC VÀ CÔNG NGHỆ

### 1.1. Kiến trúc tổng quan
- **Backend:** Java 17, Spring Boot 3+ (Spring Web, Spring Data JPA, Spring Validation).
- **Database:** Microsoft SQL Server. Hệ thống được thiết kế để tận dụng các tính năng của MSSQL như `ROWVERSION` cho Optimistic Locking và `UNIQUEIDENTIFIER` cho Khóa chính.
- **Kiến trúc phân lớp (Layered Architecture):**
    - `Controller`: Tầng giao tiếp với bên ngoài, chịu trách nhiệm nhận request, trả về response và điều hướng. Bao gồm cả REST API và Web Controller cho giao diện.
    - `Service`: Tầng chứa toàn bộ logic nghiệp vụ (business logic). Đây là nơi xử lý các quy tắc phức tạp như kiểm tra tín chỉ, môn thay thế, điều kiện đăng ký...
    - `Repository`: Tầng truy cập dữ liệu, sử dụng Spring Data JPA để tương tác với Database một cách hiệu quả.
    - `Entity`: Các đối tượng Java được map 1-1 với các bảng trong cơ sở dữ liệu.
- **Frontend (UI tích hợp):** Giao diện được xây dựng bằng HTML/CSS/JS thuần túy, render phía server (Server-side Rendering) thông qua **Thymeleaf**. Cách tiếp cận này giúp hệ thống cực kỳ nhẹ, không yêu cầu các framework frontend phức tạp.
- **API Documentation:** Tự động sinh tài liệu API bằng **SpringDoc (Swagger)**, giúp việc kiểm thử và tích hợp trở nên dễ dàng.

### 1.2. Các nghiệp vụ (Business Logic) cốt lõi
Hệ thống xử lý các quy tắc kinh doanh chặt chẽ trong quá trình đăng ký môn học:

*   **Thời gian đăng ký:** Hệ thống chặn bất kỳ request nào nằm ngoài khung giờ `start_time` và `end_time` của một đợt đăng ký (Registration Period).
*   **Danh sách môn mở (Course Offerings):** Sinh viên không thể đăng ký tùy ý toàn bộ các môn trong trường. Admin phải chủ động đưa các môn (Gán số Slot tối đa) vào trong đợt đăng ký (Period) thì sinh viên mới có thể nhìn thấy và đăng ký.
*   **Môn học tương đương / Thay thế (Equivalent Courses):** 
    *   Nếu môn A (ví dụ: IT101) bị thay thế bởi môn B (IT102), hệ thống sẽ chủ động **ẩn** môn A khỏi danh sách môn mở để sinh viên không đăng ký nhầm.
    *   Hệ thống sẽ ép môn B kế thừa tính chất của môn A. Ví dụ: Nếu sinh viên Tạch môn A, hệ thống sẽ báo sinh viên phải "Học lại" đối với môn B.
*   **Trạng thái theo Điểm (Grades Logic):** API sẽ chủ động đánh giá điểm số lịch sử của sinh viên:
    *   `Chưa học` ➡️ Cho phép "Học mới" (Type = 1).
    *   `Điểm < 4.0` ➡️ Bắt buộc "Học lại" (Type = 2). Báo màu đỏ (Failed).
    *   `Điểm >= 4.0 và < 7.0` ➡️ Cho phép "Cải thiện" (Type = 3). Báo màu vàng (Improvable).
    *   `Điểm >= 7.0` ➡️ Khóa nút Đăng ký. Không cho phép đăng ký lại (Passed).
*   **Số tín chỉ tối đa:** Kiểm tra tổng số tín chỉ mà sinh viên đang đăng ký trong đợt. Nếu vượt quá mức quy định của đợt (Ví dụ max = 25), lập tức văng lỗi báo `400 Bad Request`.
*   **Ràng buộc trùng lặp:** Hệ thống sử dụng cả truy vấn JPA lẫn Optimistic Locking (cột `row_version`) để chặn sinh viên spam click nút Đăng ký tạo ra 2 bản ghi cho 1 môn.
*   **Quyền Admin (Force Register):** Admin có quyền sử dụng tính năng "Force Register", bỏ qua toàn bộ mọi logic kiểm tra (Số tín chỉ, điểm, môn bị cấm, v.v...) để ép đăng ký cho sinh viên.
*   **Hủy đăng ký:** Chỉ cho phép hủy khi sinh viên chưa đóng tiền (`is_paid = false`) và trạng thái đang là `1` (Thành công) hoặc `2` (Đang chờ).
*   **Bảo mật & Phân quyền:** Sử dụng cơ chế giả lập (Fake Auth) qua `localStorage` để phân quyền giữa Student và Admin trên giao diện. Các API được phân tách rõ ràng theo từng vai trò.
