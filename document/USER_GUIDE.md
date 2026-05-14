# HƯỚNG DẪN SỬ DỤNG (USER GUIDE)

Tài liệu này cung cấp hướng dẫn chi tiết cách thức sử dụng và vận hành **Hệ thống Đăng ký Môn học (Course Registration System)** thông qua giao diện Web được tích hợp sẵn.

---

## 1. CHUẨN BỊ BAN ĐẦU
1. **Môi trường:** Đảm bảo bạn đã cài đặt Java 17, Maven và MS SQL Server.
2. **Khởi chạy ứng dụng:** Chạy class `DemoApplication.java` từ IDE của bạn hoặc dùng lệnh `mvn spring-boot:run`. Ứng dụng mặc định sẽ khởi chạy ở địa chỉ `http://localhost:8080`.
3. **Cơ sở dữ liệu (Seed Data):** Hệ thống có thể tự động nạp dữ liệu mẫu (các môn học, đợt đăng ký, quy tắc thay thế và điểm số) từ script `src/main/resources/data.sql` khi khởi động.
    - Trong dữ liệu mẫu, đã có sẵn một sinh viên giả lập với `student_id = 88888888-8888-8888-8888-888888888888`. Sinh viên này đã được cấu hình các mức điểm khác nhau để phục vụ việc test logic (Rớt, Pass, Chưa học, v.v...).

---

## 2. ĐĂNG NHẬP VÀ PHÂN QUYỀN (Fake Auth)

Hệ thống sử dụng cơ chế đăng nhập giả lập bằng `localStorage` để thuận tiện cho việc test.

1.  Mở trình duyệt, truy cập: **`http://localhost:8080/`**
2.  Màn hình **Login Simulation** hiện ra:
    *   **User ID:** Nhập UUID của sinh viên (Mặc định hãy để: `88888888-8888-8888-8888-888888888888`).
    *   **Role:** Chọn vai trò `Student` hoặc `Admin`.
3.  Bấm nút **"Enter System"**. Tùy thuộc vào Role bạn chọn, hệ thống sẽ điều hướng bạn đến Dashboard tương ứng.

---

## 3. GIAO DIỆN QUẢN TRỊ VIÊN (ADMIN DASHBOARD)

Sau khi đăng nhập với quyền Admin, bạn sẽ được chuyển đến `http://localhost:8080/admin`.
Giao diện được chia làm 3 tab chính:

### 3.1. Tab "Registration Periods" (Quản lý các đợt đăng ký)
-   **Tạo đợt đăng ký:** Điền các thông tin vào Form "Quick Create Registration Period" (Tên, Mã kỳ học, Giờ bắt đầu, Giờ kết thúc, Max/Min Credits...) rồi bấm **"Create Period"**.
-   **Danh sách đợt:** Bảng sẽ liệt kê các đợt hiện có. Bạn có thể bấm "Delete" để xóa hoặc bấm **"Manage Offerings"** để chuyển sang màn hình quản lý các lớp môn học cụ thể cho đợt đó.

### 3.2. Màn hình "Manage Offerings" (Mở lớp cho sinh viên đăng ký)
*(Màn hình này chỉ hiện ra khi bạn bấm nút "Manage Offerings" ở Tab Registration Periods)*
-   **Bulk Add Course Offerings:** Đây là tính năng nhập liệu hàng loạt.
    -   **Course IDs:** Paste một danh sách các UUID của khóa học (lấy từ bảng `courses` trong DB). Có thể cách nhau bằng dấu cách (space) hoặc xuống dòng (Enter).
    -   **Max Slots:** Chỉ định số lượng sinh viên tối đa có thể đăng ký cho các lớp này.
    -   Bấm **"Add Offerings"**. Lập tức các môn học này sẽ "hiển thị" trên màn hình của sinh viên.
-   **Danh sách Offerings:** Hiển thị các môn đang mở kèm chức năng "Remove" để đóng lớp.

### 3.3. Tab "Equivalent Courses" (Quản lý Môn học tương đương / thay thế)
Nơi Admin thiết lập các quy tắc môn thay thế (Ví dụ: Mã môn cũ thay bằng Mã môn mới do đổi chương trình học).
-   Điền `Original Course ID` (Môn bị thay thế).
-   Điền `Equivalent Course ID` (Môn thay thế).
-   Type mặc định = `1` (Replace).
-   Bấm **"Create"**.
-   *Lưu ý:* Ngay khi quy tắc này được tạo, nếu môn cũ vẫn đang được mở trong "Offerings", nó sẽ bị **ẩn** khỏi màn hình của Sinh viên. Thay vào đó, nếu sinh viên bị điểm kém môn cũ, hệ thống sẽ ép sinh viên học lại bằng môn mới.

### 3.4. Tab "All Registrations"
-   Xem danh sách tất cả các lượt đăng ký thành công của toàn bộ sinh viên.
-   **Force Register:** Form dành cho Admin để ép đăng ký cho sinh viên, bỏ qua toàn bộ mọi giới hạn (không kiểm tra ngày tháng, không kiểm tra điểm số, tín chỉ). Bấm "Force Register" và F5 để xem kết quả.

---

## 4. GIAO DIỆN SINH VIÊN (STUDENT DASHBOARD)

Sau khi đăng nhập với quyền Student, bạn sẽ được chuyển đến `http://localhost:8080/student`.
Hệ thống sẽ ngay lập tức fetch lịch sử điểm của bạn (`/api/registration/grades/me`) và lưu vào bộ nhớ.

Giao diện chia làm 2 Tab chính:

### 4.1. Tab "Registration Periods"
-   Hiển thị danh sách các đợt đăng ký **đang mở (Active)**. Các đợt đóng hoặc chưa tới ngày sẽ không hiện.
-   Bấm nút **"View Offerings"** ở đợt tương ứng để chuyển sang màn hình Chọn Môn Học.

### 4.2. Màn hình "Available Courses (Offerings)"
*(Màn hình quan trọng nhất của hệ thống)*
-   Hiển thị danh sách các môn được phép đăng ký trong đợt này.
-   **Hệ thống tự động phân loại logic rất chặt chẽ:**
    -   **Cột "My Grade Info":**
        -   Nếu bạn chưa có điểm môn này ➡️ Hiển thị Badge `New (Chưa học)`.
        -   Nếu bạn tạch môn (<4.0) ➡️ Hiển thị Badge `Failed (Học lại)` màu đỏ kèm điểm số.
        -   Nếu bạn điểm kém (>=4.0 và <7.0) ➡️ Hiển thị Badge `Improvable (Cải thiện)` màu vàng.
        -   Nếu bạn điểm cao (>=7.0) ➡️ Hiển thị Badge `Passed (Đạt)` màu xanh. Nút đăng ký sẽ bị **khóa (Disabled)**.
        -   Đặc biệt: Nếu môn hiển thị là một "Môn Thay Thế" cho một môn cũ bạn từng rớt, hệ thống sẽ hiển thị thêm ghi chú màu xanh: `(Môn thay thế cho: [Tên môn cũ])` và bê nguyên điểm rớt của môn cũ lên môn mới này.
    -   **Cột "Registration Type":** Tự động khóa chết text cứng (`Học mới`, `Học lại`, `Cải thiện`) tùy theo trạng thái điểm ở trên, sinh viên không cần chọn.
    -   **Cột "Action":**
        -   Nếu còn Slot và đủ điều kiện: Nút màu xanh `Register`.
        -   Nếu bạn ấn Register và thành công: Nút tự động chuyển thành nút màu đỏ `Cancel` cho phép bạn hủy ngay lập tức trên trang này.
        -   Nếu hết Slot: Hiện chữ `Full` và nút bị khóa.

### 4.3. Tab "My Registrations"
-   Nơi hiển thị toàn bộ lịch sử các môn bạn đã đăng ký thành công.
-   Bảng hiển thị chi tiết: Thời gian đăng ký, Tên đợt, Tên môn học (kèm UUID nhỏ bên dưới), Số tín chỉ, Loại hình học (Mới/Lại/Cải thiện), Tình trạng thanh toán, và Trạng thái (Thành công/Chờ/Hủy).
-   **Hủy môn:** Cột cuối cùng có nút **"Cancel"**. Nếu bạn đã nộp tiền (`isPaid = true`) hoặc trạng thái đang là Đã hủy (`status = 3`), nút này sẽ tự động **khóa**. Bấm Cancel sẽ yêu cầu xác nhận và hủy môn ngay lập tức.

---

## 5. THỬ NGHIỆM API (SWAGGER)

Ngoài việc thao tác bằng Giao diện Web, bạn có thể gọi thẳng vào các API Core của hệ thống thông qua Swagger UI.
Truy cập: **[http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)**
Tại đây, bạn có thể thực thi các lệnh GET/POST/PUT/PATCH/DELETE một cách dễ dàng.
