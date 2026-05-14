# Hướng dẫn Test API (Sử dụng Postman/Postwoman)

Dưới đây là các kịch bản test (Test Cases) kèm theo dữ liệu JSON để bạn có thể gửi request qua API.
Dữ liệu mồi (seed data) đã được tạo sẵn trong file `src/main/resources/data.sql` với các UUID cố định để bạn dễ dàng test.

*Chú ý: Đảm bảo Spring Boot đang chạy ở cổng `8080`. Chỉnh lại Base URL nếu cần.*

---

## Dữ liệu mặc định (từ file `data.sql`)
- **Sinh viên ID (Fake):** `88888888-8888-8888-8888-888888888888`
- **Đợt đăng ký (Active):** `aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa`
- **Các môn học:**
  - `11111111-1111-1111-1111-111111111111` (Java cơ bản - 3 tín chỉ)
  - `22222222-2222-2222-2222-222222222222` (CTDL & GT - 3 tín chỉ - Tương đương thay thế được môn Java)
  - `33333333-3333-3333-3333-333333333333` (Cơ sở dữ liệu - 3 tín chỉ)

---

## 1. Test Sinh viên Đăng ký Môn học (Thành công)
Đăng ký môn học "Java cơ bản".

**Request:**
- **URL:** `POST http://localhost:8080/api/registration`
- **Body (JSON):**
```json
{
  "studentId": "88888888-8888-8888-8888-888888888888",
  "courseId": "11111111-1111-1111-1111-111111111111",
  "registrationPeriodId": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "registrationType": 1
}
```
**Kỳ vọng:** API trả về HTTP `201 Created` và `success: true`. Ghi lại chuỗi UUID của đăng ký này để test chức năng hủy.

---

## 2. Test Lỗi: Sinh viên Đăng ký Trùng Môn
Tiếp tục gửi lại y hệt Request số 1.

**Request:**
- **URL:** `POST http://localhost:8080/api/registration`
- **Body (JSON):** *(giữ nguyên JSON trên)*

**Kỳ vọng:** API trả về HTTP `409 Conflict` với message "You have already registered for this course".

---

## 3. Test Lỗi: Đăng ký Môn Tương Đương
Sinh viên đã đăng ký "Java cơ bản" (IT101). Bây giờ thử đăng ký tiếp môn "CTDL & GT" (IT102), mà IT102 là môn thay thế của IT101. Hệ thống phải chặn lại.

**Request:**
- **URL:** `POST http://localhost:8080/api/registration`
- **Body (JSON):**
```json
{
  "studentId": "88888888-8888-8888-8888-888888888888",
  "courseId": "22222222-2222-2222-2222-222222222222",
  "registrationPeriodId": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "registrationType": 1
}
```
**Kỳ vọng:** API trả về HTTP `409 Conflict` với message "You cannot register for an equivalent course...".

---

## 4. Test Lỗi: Đợt đăng ký không tồn tại
Cố tình truyền một `registrationPeriodId` sai (không có trong DB).

**Request:**
- **URL:** `POST http://localhost:8080/api/registration`
- **Body (JSON):**
```json
{
  "studentId": "88888888-8888-8888-8888-888888888888",
  "courseId": "33333333-3333-3333-3333-333333333333",
  "registrationPeriodId": "00000000-0000-0000-0000-000000000000",
  "registrationType": 1
}
```
**Kỳ vọng:** API trả về HTTP `404 Not Found` với message "Registration period not found".

---

## 5. Test Lấy Danh sách Môn Đã Đăng Ký
Để lấy danh sách các môn sinh viên này vừa đăng ký.

*(Lưu ý: API hiện tại trong code đang dùng UUID random trong controller như một placeholder bảo mật, bạn nên vào file `RegistrationController.java` sửa hàm `getMyRegistrations` dòng `UUID studentId = UUID.randomUUID();` thành hardcode `UUID studentId = UUID.fromString("88888888-8888-8888-8888-888888888888");` để test nhanh)*

**Request:**
- **URL:** `GET http://localhost:8080/api/registration/me`

**Kỳ vọng:** API trả về danh sách mảng chứa record của môn "Java cơ bản" vừa tạo ở Bước 1.

---

## 6. Test Admin Bỏ qua Lỗi (Force Register)
Tương tự Bước 3 (Lỗi môn tương đương), nhưng lần này là Admin thao tác và được quyền dùng cờ `force: true` để ép đăng ký.

**Request:**
- **URL:** `POST http://localhost:8080/api/admin/registration/course-registrations`
- **Body (JSON):**
```json
{
  "studentId": "88888888-8888-8888-8888-888888888888",
  "courseId": "22222222-2222-2222-2222-222222222222",
  "registrationPeriodId": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "registrationType": 1
}
```
**Kỳ vọng:** API trả về HTTP `201 Created` dù sinh viên bị lỗi môn tương đương, vì Admin được cấp cờ force.

---

## 7. Test Sinh viên Hủy Môn Học
Dùng UUID nhận được ở Bước 1 (phần `data.id` trả về lúc tạo thành công) để điền vào URL dưới đây.

**Request:**
- **URL:** `PATCH http://localhost:8080/api/registration/{thay_uuid_dang_ky_vao_day}/cancel`

*(Lưu ý: Tương tự hàm GET, hàm Cancel trong Controller hiện đang mock UUID user. Cần vào `RegistrationController.java` dòng `UUID studentId = UUID.randomUUID();` đổi thành `88888888-8888-8888-8888-888888888888` để có quyền sửa).*

**Kỳ vọng:** Trạng thái đăng ký được đổi thành `3` (Đã hủy). API trả về `200 OK`.
