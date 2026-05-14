-- Test data cho bảng courses
-- Xóa dữ liệu cũ nếu cần (cẩn thận khi chạy trên DB thật)
-- DELETE FROM course_registrations;
-- DELETE FROM equivalent_courses;
-- DELETE FROM registration_periods;
-- DELETE FROM courses;

-- Thêm 3 môn học mẫu
INSERT INTO courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES
('11111111-1111-1111-1111-111111111111', 'IT101', N'Lập trình Java cơ bản', 'Basic Java Programming', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
('22222222-2222-2222-2222-222222222222', 'IT102', N'Cấu trúc dữ liệu và giải thuật', 'Data Structures and Algorithms', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
('33333333-3333-3333-3333-333333333333', 'IT103', N'Cơ sở dữ liệu', 'Database Systems', 3.0, 30.0, 15.0, 45.0, 1, GETDATE());

-- Thêm 1 đợt đăng ký môn học (Registration Period)
INSERT INTO registration_periods (id, name, semester_id, start_time, end_time, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Đợt đăng ký Học kỳ 1 - 2024', '99999999-9999-9999-9999-999999999999', GETDATE(), DATEADD(day, 7, GETDATE()), 25, 10, 1, 1, GETDATE());

-- Thêm 1 môn học tương đương (Equivalent Course: IT101 tương đương với IT102)
-- Giả sử equivalence_type = 1 là môn học thay thế
INSERT INTO equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at)
VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 1, GETDATE(), 1, N'Học IT102 có thể thay cho IT101', GETDATE());
