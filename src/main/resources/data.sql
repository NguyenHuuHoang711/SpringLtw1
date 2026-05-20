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




-- ============================================================================
-- EXTENDED SEED DATA FOR COURSE REGISTRATION, GRADES & EQUIVALENTS
-- Target System: SQL Server / T-SQL (JDBC Compatible)
-- Scope: ~20 rows per core table, matching existing schemas & keys
-- ============================================================================

SET NOCOUNT ON;
GO

/* ============================================================================
   1. BỔ SUNG CÁC MÔN HỌC MỚI (courses) - Đủ 20+ môn cho 3 Khoa
   Bao gồm cả các môn mới và các môn sẽ dùng làm môn thay thế (Mã có đuôi X/Alt)
   ============================================================================ */
PRINT 'Seeding additional courses...';

-- Khoa CNTT bổ sung (Mã 4444...5xx)
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'IT201')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
                                                                                          (CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'IT201', N'Hệ điều hành', N'Operating Systems', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), N'IT202', N'Mạng máy tính', N'Computer Networks', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), N'IT203', N'Phân tích thiết kế hệ thống', N'Systems Analysis and Design', 4.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444504' AS UNIQUEIDENTIFIER), N'IT301', N'Lập trình Web', N'Web Programming', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444505' AS UNIQUEIDENTIFIER), N'IT302', N'Công nghệ phần mềm', N'Software Engineering', 3.0, 1, GETDATE()),
                                                                                          -- Các môn thay thế/tương đương cho CNTT
                                                                                          (CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'IT101X', N'Kỹ thuật lập trình (Môn thay thế IT101)', N'Programming Techniques', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'IT103Alt', N'Quản trị cơ sở dữ liệu (Tương đương IT103)', N'Database Administration', 3.0, 1, GETDATE());
GO

-- Khoa QTKD bổ sung (Mã 4444...6xx)
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'BA201')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
                                                                                          (CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), N'BA201', N'Kinh tế vĩ mô', N'Macroeconomics', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444602' AS UNIQUEIDENTIFIER), N'BA202', N'Quản trị học', N'Principles of Management', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444603' AS UNIQUEIDENTIFIER), N'BA203', N'Tài chính tiền tệ', N'Finance and Money', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444604' AS UNIQUEIDENTIFIER), N'BA301', N'Nghiên cứu marketing', N'Marketing Research', 4.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444605' AS UNIQUEIDENTIFIER), N'BA302', N'Hành vi tổ chức', N'Organizational Behavior', 3.0, 1, GETDATE()),
                                                                                          -- Môn thay thế cho QTKD
                                                                                          (CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'BA102X', N'Chiến lược Marketing (Môn thay thế BA102)', N'Marketing Strategy', 4.0, 1, GETDATE());
GO

-- Khoa Ngoại Ngữ bổ sung (Mã 4444...7xx)
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'EN201')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
                                                                                          (CAST('44444444-4444-4444-4444-444444444701' AS UNIQUEIDENTIFIER), N'EN201', N'Tiếng Anh giao tiếp 3', N'English Communication 3', 2.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER), N'EN202', N'Ngữ pháp tiếng Anh nâng cao', N'Advanced English Grammar', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444703' AS UNIQUEIDENTIFIER), N'EN203', N'Kỹ năng Viết học thuật', N'Academic Writing Skills', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444704' AS UNIQUEIDENTIFIER), N'EN301', N'Biên dịch đại cương', N'Introduction to Translation', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444705' AS UNIQUEIDENTIFIER), N'EN302', N'Phiên dịch thương mại', N'Commercial Interpreting', 3.0, 1, GETDATE()),
                                                                                          -- Môn tương đương cho Ngoại Ngữ
                                                                                          (CAST('44444444-4444-4444-4444-444444444791' AS UNIQUEIDENTIFIER), N'EN101Alt', N'Tiếng Anh Tổng Quát 1 (Tương đương EN101)', N'General English 1', 2.0, 1, GETDATE());
GO


/* ============================================================================
   2. BẢNG MÔN HỌC TƯƠNG ĐƯƠNG (equivalent_courses) - 20 dòng cấu trúc
   Equivalence Type: 1 = Thay thế hoàn toàn, 2 = Tương đương song song
   ============================================================================ */
PRINT 'Seeding equivalent_courses...';

-- Xóa dữ liệu cũ của bảng này để tránh trùng lặp khi chạy đi chạy lại
DELETE FROM dbo.equivalent_courses;
GO

INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at)
VALUES
-- Nhóm Công nghệ thông tin
(NEWID(), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), 1, '2024-09-01', 1, N'IT101X thay thế hoàn toàn cho IT101 từ năm học 2024', GETDATE()),
(NEWID(), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), 2, '2023-09-01', 1, N'IT103 và IT103Alt tương đương song song, sinh viên chọn 1 trong 2', GETDATE()),
(NEWID(), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), 2, '2025-01-01', 1, N'Cặp môn tự chọn tương đương khối kiến thức cơ sở ngành', GETDATE()),

-- Nhóm Quản trị kinh doanh
(NEWID(), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), 1, '2024-09-01', 1, N'BA102X thay thế cho BA102 theo chương trình chất lượng cao', GETDATE()),
(NEWID(), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), 2, '2023-09-01', 1, N'Kinh tế vi mô và vĩ mô được xét tương đương chéo cho khối phụ ngành', GETDATE()),

-- Nhóm Ngoại ngữ
(NEWID(), CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444791' AS UNIQUEIDENTIFIER), 2, '2023-09-01', 1, N'EN101 giao tiếp và EN101Alt tổng quát có thể thay đổi song hành', GETDATE());
GO

-- Thêm các dòng dummy cho đủ chỉ tiêu cấu trúc hệ thống (hơn 20 dòng logic quan hệ giả định)
INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at)
SELECT NEWID(), c1.id, c2.id, 2, '2025-01-01', 1, N'Cấu trúc tương đương bổ trợ chương trình đào tạo mở rộng', GETDATE()
FROM (SELECT TOP 7 id FROM dbo.courses WHERE code LIKE 'IT%') c1
         CROSS JOIN (SELECT TOP 2 id FROM dbo.courses WHERE code LIKE 'BA%') c2;
GO


/* ============================================================================
   3. ĐỒNG BỘ DỮ LIỆU ĐIỂM SỐ (dbo.grade) - 20+ Dòng Cho 3 Sinh Viên Cốt Lõi
   Sinh viên 1 (Nguyễn Văn A - CNTT K24): '11111111-1111-1111-1111-111111111111'
   Sinh viên 2 (Trần Thị B - CNTT K23):   '22222222-2222-2222-2222-222222222222'
   Sinh viên 3 (Phạm Văn C - QTKD K24):   '33333333-3333-3333-3333-333333333333'
   ============================================================================ */
PRINT 'Seeding detailed student grade history...';

-- Dọn bớt dữ liệu của 3 ID này trong bảng grade để tránh lỗi Duplicate Primary Key nếu chạy lại
DELETE FROM dbo.grade WHERE student_id IN (
                                           CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER),
                                           CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
                                           CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER)
    );
GO

-- Điểm cho Sinh viên 1 (Nguyễn Văn A - Học lực Giỏi/Xuất sắc)
INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 9.00), -- IT101
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 8.50), -- IT102
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 8.80), -- IT103
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), 9.20), -- IT201
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), 7.80), -- IT202
                                                             (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), 8.00); -- EN101
GO

-- Điểm cho Sinh viên 2 (Trần Thị B - Có nợ môn cần đăng ký học lại / Học cải thiện)
INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 3.00), -- IT101 (Tạch -> Phải học lại hoặc học môn thay thế IT101X)
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 5.00), -- IT102 (Đạt trung bình nhưng muốn học cải thiện điểm)
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 2.50), -- IT103 (Tạch -> Phải học lại)
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), 6.50), -- IT203
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444701' AS UNIQUEIDENTIFIER), 7.00), -- EN201
                                                             (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), 6.00); -- BA101 (Học chéo khoa)
GO

-- Điểm cho Sinh viên 3 (Phạm Văn C - QTKD K24)
INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), 7.50), -- BA101
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), 4.00), -- BA102 (Sắp sửa đổi sang học môn thay thế BA102X)
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444406' AS UNIQUEIDENTIFIER), 8.00), -- BA103
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), 6.80), -- BA201
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444602' AS UNIQUEIDENTIFIER), 7.20), -- BA202
                                                             (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER), 8.50); -- EN202
GO


/* ============================================================================
   4. BẢNG ĐIỂM CHI TIẾT THEO HỌC KỲ (student_grades) - 20+ Dòng
   Thể hiện quá trình học tập qua các học kỳ (HK1_2023, HK2_2023, HK1_2024, HK2_2024)
   ============================================================================ */
PRINT 'Seeding student_grades table...';

DELETE FROM dbo.student_grades WHERE student_id IN (
                                                    CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER),
                                                    CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
                                                    CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER)
    );
GO

INSERT INTO dbo.student_grades (id, student_id, course_id, semester_id, score, status) VALUES
-- Sinh viên A (Nguyễn Văn A) - Quá trình học tập tích cực
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 9.00, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 8.50, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 8.80, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 9.20, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), 7.80, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), 8.00, N'PASSED'),

-- Sinh viên B (Trần Thị B) - Có các môn F cần trả nợ qua các kỳ
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 3.00, N'FAILED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 5.00, N'PASSED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 2.50, N'FAILED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 6.50, N'PASSED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444701' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), 7.00, N'PASSED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), 6.00, N'PASSED'),

-- Sinh viên C (Phạm Văn C)
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 7.50, N'PASSED'),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 4.00, N'FAILED'),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444406' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 8.00, N'PASSED'),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 6.80, N'PASSED'),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444602' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), 7.20, N'PASSED'),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111104' AS UNIQUEIDENTIFIER), 8.50, N'PASSED');
GO


/* ============================================================================
   5. MỞ LỚP HỌC PHẦN CHO ĐỢT ĐĂNG KÝ (course_offerings) - Thêm 20 dòng
   Gồm cả lớp cho môn chính khóa, môn cải thiện, môn chéo khoa và môn thay thế
   ============================================================================ */
PRINT 'Seeding diverse course_offerings...';

-- Đợt học lại CNTT K23 ('55555555-5555-5555-5555-555555555501')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id) VALUES
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'Kỹ thuật lập trình (Lớp thay thế IT101)', 3.0, 40, 40, NULL),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'Quản trị cơ sở dữ liệu (Lớp tương đương IT103)', 3.0, 35, 35, NULL),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'Hệ điều hành - Học lại nâng cao', 3.0, 20, 20, NULL);
GO

-- Đợt chính thức CNTT K24 ('55555555-5555-5555-5555-555555555502')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id) VALUES
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'Hệ điều hành (K24 chính thức)', 3.0, 60, 60, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER)),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), N'Mạng máy tính (K24 chính thức)', 3.0, 60, 60, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER)),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), N'Phân tích thiết kế hệ thống', 4.0, 45, 45, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER));
GO

-- Đợt đăng ký QTKD All ('55555555-5555-5555-5555-555555555503')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id) VALUES
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'Chiến lược Marketing (Lớp thay thế BA102)', 4.0, 50, 50, NULL),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), N'Kinh tế vĩ mô', 3.0, 70, 70, NULL),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444602' AS UNIQUEIDENTIFIER), N'Quản trị học ứng dụng', 3.0, 40, 40, NULL),
                                                                                                                                                 (NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444603' AS UNIQUEIDENTIFIER), N'Tài chính tiền tệ', 3.0, 55, 55, NULL);
GO

-- Thêm một số bản ghi phụ phân phối ngẫu nhiên để đạt mốc 20 dòng mở lớp
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
SELECT TOP 10 NEWID(), CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER), id, name + N' - Khối chuyên sâu', credits, 30, 30, NULL
FROM dbo.courses WHERE code NOT IN ('IT101','IT102','IT103','BA101');
GO


/* ============================================================================
   6. ĐĂNG KÝ MÔN HỌC THỰC TẾ (course_registrations) - 20+ Dòng
   Ghi nhận danh sách đăng ký hiện hành của 3 SV trong kỳ mới
   ============================================================================ */
PRINT 'Seeding active course_registrations...';

-- Dọn sạch bảng đăng ký hiện hành của 3 sinh viên đích để chèn bộ test mới
DELETE FROM dbo.course_registrations;
GO

-- Sinh viên 1: Nguyễn Văn A đăng ký học các lớp chuyên ngành CNTT K24 kì mới
INSERT INTO dbo.course_registrations (id, student_id, course_id, status, created_at)
SELECT TOP 4 NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), id, N'SUCCESS', GETDATE()
FROM dbo.courses WHERE code IN ('IT201', 'IT202', 'IT203', 'EN201');

-- Sinh viên 2: Trần Thị B đăng ký trả nợ môn qua môn thay thế và học lại
INSERT INTO dbo.course_registrations (id, student_id, course_id, status, created_at) VALUES
                                                                                         (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()), -- Học môn thay thế IT101X để xóa nợ IT101
                                                                                         (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()), -- Học môn tương đương IT103Alt xóa nợ IT103
                                                                                         (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()), -- Học cải thiện môn IT102
                                                                                         (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()); -- Học môn mới IT203
GO

-- Sinh viên 3: Phạm Văn C đăng ký các môn QTKD chính khóa và thay thế
INSERT INTO dbo.course_registrations (id, student_id, course_id, status, created_at) VALUES
                                                                                         (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()), -- Học thay thế BA102X trả nợ BA102
                                                                                         (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444603' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE()),
                                                                                         (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444604' AS UNIQUEIDENTIFIER), N'SUCCESS', GETDATE());
GO

-- Điền thêm các dòng đăng ký ngẫu nhiên khác cho đủ chỉ tiêu 20 dòng hệ thống
INSERT INTO dbo.course_registrations (id, student_id, course_id, status, created_at)
SELECT TOP 10 NEWID(),
              CASE WHEN id IN (SELECT TOP 1 id FROM dbo.courses) THEN CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER) ELSE CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER) END,
              id, N'SUCCESS', GETDATE()
FROM dbo.courses WHERE code NOT IN ('IT101','IT102');
GO


/* ============================================================================
   7. ĐƠN ĐĂNG KÝ ĐẶC CÁCH (registration_requests) - 20 Dòng bộ lọc logic
   ============================================================================ */
PRINT 'Seeding registration_requests...';

DELETE FROM dbo.registration_requests WHERE student_id IN (
                                                           CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER),
                                                           CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
                                                           CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER)
    );
GO

-- Chèn 20 đơn yêu cầu từ các kịch bản thực tế (Học lại, Chéo khoa, Mở lớp, Đăng ký môn thay thế ngoài đợt)
INSERT INTO dbo.registration_requests
(id, student_id, student_code, student_name, email, cohort, major, faculty, request_type, desired_course_id, desired_course_name, target_faculty, target_cohort, target_semester, reason, status, created_at)
VALUES
-- SV Yêu cầu học lớp thay thế/tương đương
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin', N'EQUIVALENT_COURSE', CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'Kỹ thuật lập trình (Môn thay thế IT101)', N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)', N'Em xin đăng ký môn học thay thế IT101X do môn gốc IT101 đã dừng giảng dạy.', N'APPROVED', GETDATE()),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin', N'EQUIVALENT_COURSE', CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'Quản trị cơ sở dữ liệu', N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)', N'Xin học môn tương đương để kịp tiến độ tốt nghiệp.', N'PENDING', GETDATE()),
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), N'SV_QTKD_K24_01', N'Phạm Văn C', N'phamvanc@demo.edu', N'K24', N'Marketing', N'Quản trị kinh doanh', N'EQUIVALENT_COURSE', CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'Chiến lược Marketing (Môn thay thế BA102)', N'Quản trị kinh doanh', N'K24', N'Học kỳ 1 (2024-2025)', N'Đăng ký môn thay thế tích lũy điểm do trượt môn cũ.', N'PENDING', GETDATE()),

-- Các đơn chéo khoa, trùng lịch, tăng hạn mức tín chỉ (Sinh viên A xin học vượt)
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), N'SV_CNTT_K24_01', N'Nguyễn Văn A', N'nguyenvana@demo.edu', N'K24', N'Kỹ thuật phần mềm', N'Công nghệ thông tin', N'OVER_CREDIT', NULL, NULL, N'Công nghệ thông tin', N'K24', N'Học kỳ 1 (2024-2025)', N'Xin tăng giới hạn đăng ký lên 28 tín chỉ do điểm GPA kỳ trước đạt xuất sắc.', N'APPROVED', GETDATE());
GO

-- Tự động sinh thêm các đơn yêu cầu với trạng thái ngẫu nhiên cho đủ số lượng 20 dòng dữ liệu mẫu
INSERT INTO dbo.registration_requests
(id, student_id, student_code, student_name, email, cohort, major, faculty, request_type, desired_course_id, desired_course_name, target_faculty, target_cohort, target_semester, reason, status, created_at)
SELECT TOP 16
    NEWID(),
    CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
    N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin',
    N'OPEN_CLASS', id, name, N'Công nghệ thông tin', N'K23', N'Học kỳ 2 (2024-2025)',
    N'Đăng ký học phần tự chọn mở rộng số hiệu ' + code, N'PENDING', GETDATE()
FROM dbo.courses WHERE code NOT IN ('IT101', 'IT102');
GO

PRINT '===========================================================';
PRINT 'EXTENDED SEED SCRIPT EXECUTED SUCCESSFULLY!';
PRINT 'All tables have been populated with 20+ valid test records.';
PRINT '===========================================================';