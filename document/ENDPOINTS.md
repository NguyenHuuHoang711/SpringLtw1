# API Endpoints Documentation

Tài liệu này liệt kê toàn bộ các API của Hệ thống Đăng ký Môn học (Course Registration System).
Tất cả các API đều trả về response theo chuẩn JSON thống nhất:

```json
{
  "success": true,
  "data": {},
  "message": "Thông báo trạng thái"
}
```

---

## 🎓 1. STUDENT APIs (Dành cho Sinh Viên)
**Base Path:** `/api/registration`

| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/periods/active` | *None* | Lấy danh sách các đợt đăng ký môn học đang mở và có hiệu lực (Active & Open). |
| **GET** | `/offerings` | `period_id` (UUID) | Lấy danh sách các môn học được mở (Course Offerings) trong một đợt đăng ký cụ thể. |
| **GET** | `/grades/me` | `student_id` (UUID) | Lấy toàn bộ lịch sử điểm số của sinh viên đang đăng nhập. Dùng để tính toán môn học lại / cải thiện. |
| **GET** | `/equivalent-courses` | *None* | Lấy danh sách các quy tắc môn học thay thế (Equivalent Courses) đang có hiệu lực trên toàn hệ thống. |
| **GET** | `/me` | `student_id` (UUID) | Lấy danh sách các môn mà sinh viên đang đăng nhập đã đăng ký. |
| **POST** | `/` | `CourseRegistrationRequest` | Gửi yêu cầu đăng ký môn học (Bao gồm Student ID, Course ID, Period ID và Registration Type). Hệ thống sẽ tự động validate tín chỉ, môn trùng, môn thay thế... |
| **PATCH** | `/{id}/cancel` | `student_id` (UUID) | Hủy một đăng ký môn học (id là UUID của bản ghi đăng ký). Chỉ được hủy khi môn chưa thanh toán (`is_paid = false`) và trạng thái chưa bị hủy. |

---

## 🛠 2. ADMIN APIs (Dành cho Quản Trị Viên)
**Base Path:** `/api/admin/registration`

### 2.1 Quản lý Đợt đăng ký (Registration Periods)
| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/periods` | *None* | Lấy danh sách tất cả các đợt đăng ký trong hệ thống. |
| **POST** | `/periods` | `RegistrationPeriodRequest` | Tạo một đợt đăng ký mới (Cấu hình thời gian, số tín chỉ tối đa/tối thiểu...). |
| **GET** | `/periods/{id}` | Path: `id` (UUID) | Lấy thông tin chi tiết của một đợt đăng ký theo ID. |
| **PUT** | `/periods/{id}` | `RegistrationPeriodRequest` | Cập nhật thông tin đợt đăng ký hiện tại. |
| **DELETE** | `/periods/{id}` | Path: `id` (UUID) | Xóa một đợt đăng ký khỏi hệ thống (Soft delete). |

### 2.2 Quản lý Lớp Môn Mở (Course Offerings)
| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/offerings` | `period_id` (UUID) | Lấy danh sách các môn học được mở trong đợt đăng ký. |
| **POST** | `/offerings` | `CourseOffering` (JSON) | Thêm 1 môn học vào đợt đăng ký (Gán số lượng slot tối đa). |
| **POST** | `/offerings/bulk` | `CourseOfferingBulkRequest` | Thêm nhanh nhiều môn học vào đợt đăng ký bằng cách truyền vào chuỗi text chứa nhiều UUID. |
| **DELETE** | `/offerings/{id}` | Path: `id` (UUID) | Xóa một môn học khỏi đợt đăng ký. |

### 2.3 Quản lý Môn học Thay thế (Equivalent Courses)
| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/equivalent-courses` | *None* | Lấy danh sách tất cả quy tắc môn học thay thế. |
| **POST** | `/equivalent-courses` | `EquivalentCourseRequest` | Tạo một quy tắc môn học tương đương / thay thế (Original Course -> Equivalent Course). |
| **GET** | `/equivalent-courses/{id}`| Path: `id` (UUID) | Lấy chi tiết một quy tắc theo ID. |
| **PUT** | `/equivalent-courses/{id}`| `EquivalentCourseRequest` | Cập nhật một quy tắc thay thế. |
| **DELETE** | `/equivalent-courses/{id}`| Path: `id` (UUID) | Xóa một quy tắc thay thế. |

### 2.4 Quản lý Đăng ký của Sinh viên
| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/course-registrations` | *None* | Xem toàn bộ danh sách đăng ký môn học của tất cả sinh viên trên toàn hệ thống. |
| **POST** | `/course-registrations` | `CourseRegistrationRequest` | Đăng ký "ép" (Force Register): Cho phép Admin đăng ký môn cho sinh viên bất chấp các ràng buộc về tín chỉ, lịch học, môn cấm... (`force=true`). |

---

## 📚 3. GLOBAL APIs (Dùng chung)
**Base Path:** `/api/courses`

| Phương thức | Endpoint | Tham số (Params / Body) | Mô tả chức năng |
| :--- | :--- | :--- | :--- |
| **GET** | `/` | `ids` (List UUID cách nhau dấu phẩy) | Trả về thông tin chi tiết (Tên môn, số tín chỉ...) của nhiều khóa học cùng một lúc dựa trên mảng UUID truyền vào. |
