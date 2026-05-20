IF OBJECT_ID('student_profiles', 'U') IS NULL
    BEGIN
        CREATE TABLE student_profiles (
                                          student_id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
                                          student_code NVARCHAR(50) NOT NULL,
                                          student_name NVARCHAR(100) NOT NULL,
                                          email NVARCHAR(100) NULL,
                                          cohort NVARCHAR(50) NULL,
                                          major NVARCHAR(100) NULL,
                                          faculty NVARCHAR(100) NULL
        );
    END
GO

IF COL_LENGTH('student_profiles', 'student_code') IS NULL
ALTER TABLE student_profiles ADD student_code NVARCHAR(50) NOT NULL DEFAULT N'';
GO
IF COL_LENGTH('student_profiles', 'student_name') IS NULL
ALTER TABLE student_profiles ADD student_name NVARCHAR(100) NOT NULL DEFAULT N'';
GO
IF COL_LENGTH('student_profiles', 'email') IS NULL
ALTER TABLE student_profiles ADD email NVARCHAR(100) NULL;
GO
IF COL_LENGTH('student_profiles', 'cohort') IS NULL
ALTER TABLE student_profiles ADD cohort NVARCHAR(50) NULL;
GO
IF COL_LENGTH('student_profiles', 'major') IS NULL
ALTER TABLE student_profiles ADD major NVARCHAR(100) NULL;
GO
IF COL_LENGTH('student_profiles', 'faculty') IS NULL
ALTER TABLE student_profiles ADD faculty NVARCHAR(100) NULL;
GO

IF NOT EXISTS (SELECT 1 FROM student_profiles WHERE student_id = CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER))
    INSERT INTO student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
    VALUES (CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), N'SV_CNTT_K24_01', N'Nguyễn Văn A', N'nguyenvana@demo.edu', N'K24', N'Kỹ thuật phần mềm', N'Công nghệ thông tin');
GO

IF NOT EXISTS (SELECT 1 FROM student_profiles WHERE student_id = CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER))
    INSERT INTO student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
    VALUES (CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin');
GO

IF NOT EXISTS (SELECT 1 FROM student_profiles WHERE student_id = CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER))
    INSERT INTO student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
    VALUES (CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), N'SV_QTKD_K24_01', N'Phạm Văn C', N'phamvanc@demo.edu', N'K24', N'Marketing', N'Quản trị kinh doanh');
GO
DELETE FROM course_registrations
WHERE id IN (
             '6F5BDC5A-A241-4572-A73B-0E009AE1A07C',
             'B1DA5A94-4664-43A0-A12F-4374AB3C762B',
             '4F3DC62C-2B10-43A8-AC80-5DF606D3033D',
             '088D0207-E94C-434A-8A62-739B05A207E1'
    );
GO


-- ============================================================================
-- EXTENDED SEED DATA FOR COURSE REGISTRATION, GRADES & EQUIVALENTS (APPEND ONLY)
-- Target System: SQL Server / T-SQL (JDBC Compatible)
-- Scope: Add ~20 rows per core table WITHOUT deleting any existing data
-- ============================================================================

SET NOCOUNT ON;
GO

/* ============================================================================
   1. BỔ SUNG CÁC MÔN HỌC MỚI (courses) - Đảm bảo đủ môn cho các học kỳ sau
   ============================================================================ */
PRINT 'Appending new courses...';

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444501')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'IT201', N'Hệ điều hành', N'Operating Systems', 3.0, 1, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444502')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), N'IT202', N'Mạng máy tính', N'Computer Networks', 3.0, 1, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444503')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), N'IT203', N'Phân tích thiết kế hệ thống', N'Systems Analysis and Design', 4.0, 1, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444504')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444504' AS UNIQUEIDENTIFIER), N'IT301', N'Lập trình Web', N'Web Programming', 3.0, 1, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444505')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444505' AS UNIQUEIDENTIFIER), N'IT302', N'Công nghệ phần mềm', N'Software Engineering', 3.0, 1, GETDATE());

-- Môn thay thế / tương đương cho khoa CNTT
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444591')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'IT101X', N'Kỹ thuật lập trình (Môn thay thế IT101)', N'Programming Techniques', 3.0, 1, GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444592')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
        (CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'IT103Alt', N'Quản trị cơ sở dữ liệu (Tương đương IT103)', N'Database Administration', 3.0, 1, GETDATE());

-- Khoa QTKD bổ sung
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444601')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
                                                                                          (CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER), N'BA201', N'Kinh tế vĩ mô', N'Macroeconomics', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444602' AS UNIQUEIDENTIFIER), N'BA202', N'Quản trị học', N'Principles of Management', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444603' AS UNIQUEIDENTIFIER), N'BA203', N'Tài chính tiền tệ', N'Finance and Money', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444604' AS UNIQUEIDENTIFIER), N'BA301', N'Nghiên cứu marketing', N'Marketing Research', 4.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444605' AS UNIQUEIDENTIFIER), N'BA302', N'Hành vi tổ chức', N'Organizational Behavior', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'BA102X', N'Chiến lược Marketing (Môn thay thế BA102)', N'Marketing Strategy', 4.0, 1, GETDATE());

-- Khoa Ngoại Ngữ bổ sung
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE id = '44444444-4444-4444-4444-444444444701')
    INSERT INTO dbo.courses (id, code, name, name_en, credits, is_active, created_at) VALUES
                                                                                          (CAST('44444444-4444-4444-4444-444444444701' AS UNIQUEIDENTIFIER), N'EN201', N'Tiếng Anh giao tiếp 3', N'English Communication 3', 2.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER), N'EN202', N'Ngữ pháp tiếng Anh nâng cao', N'Advanced English Grammar', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444703' AS UNIQUEIDENTIFIER), N'EN203', N'Kỹ năng Viết học thuật', N'Academic Writing Skills', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444704' AS UNIQUEIDENTIFIER), N'EN301', N'Biên dịch đại cương', N'Introduction to Translation', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444705' AS UNIQUEIDENTIFIER), N'EN302', N'Phiên dịch thương mại', N'Commercial Interpreting', 3.0, 1, GETDATE()),
                                                                                          (CAST('44444444-4444-4444-4444-444444444791' AS UNIQUEIDENTIFIER), N'EN101Alt', N'Tiếng Anh Tổng Quát 1 (Tương đương EN101)', N'General English 1', 2.0, 1, GETDATE());
GO


/* ============================================================================
   2. BẢNG MÔN HỌC TƯƠNG ĐƯƠNG (equivalent_courses) - 20 bản ghi quan hệ
   ============================================================================ */
PRINT 'Appending equivalent_courses...';

-- Chỉ chèn nếu bảng đang trống hoặc chưa có các cặp quan hệ cố định này
IF NOT EXISTS (SELECT 1 FROM dbo.equivalent_courses WHERE original_course_id = '44444444-4444-4444-4444-444444444401' AND equivalent_course_id = '44444444-4444-4444-4444-444444444591')
    INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at) VALUES
        (NEWID(), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), 1, '2024-09-01', 1, N'IT101X thay thế hoàn toàn cho IT101 từ năm học 2024', GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.equivalent_courses WHERE original_course_id = '44444444-4444-4444-4444-444444444403' AND equivalent_course_id = '44444444-4444-4444-4444-444444444592')
    INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at) VALUES
        (NEWID(), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), 2, '2023-09-01', 1, N'IT103 và IT103Alt tương đương song song', GETDATE());

IF NOT EXISTS (SELECT 1 FROM dbo.equivalent_courses WHERE original_course_id = '44444444-4444-4444-4444-444444444405' AND equivalent_course_id = '44444444-4444-4444-4444-444444444691')
    INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at) VALUES
        (NEWID(), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), 1, '2024-09-01', 1, N'BA102X thay thế cho BA102', GETDATE());

-- Tạo vòng lặp sinh thêm dữ liệu mẫu tương đương để đạt số lượng 20 bản ghi mà không trùng khóa chính
DECLARE @Counter INT = 1;
WHILE @Counter <= 17
    BEGIN
        INSERT INTO dbo.equivalent_courses (id, original_course_id, equivalent_course_id, equivalence_type, effect_date, is_active, note, created_at)
        VALUES (
                   NEWID(),
                   CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER),
                   CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER),
                   2, '2025-01-01', 1, N'Quan hệ tương đương bổ trợ cấu trúc test khối môn ' + CAST(@Counter AS NVARCHAR(2)), GETDATE()
               );
        SET @Counter = @Counter + 1;
    END;
GO


/* ============================================================================
   3. BẢNG ĐIỂM SỐ (dbo.grade) - Thêm lịch sử điểm cho 3 sinh viên đích
   Sinh viên 1 (Nguyễn Văn A): '11111111-1111-1111-1111-111111111111'
   Sinh viên 2 (Trần Thị B):   '22222222-2222-2222-2222-222222222222'
   Sinh viên 3 (Phạm Văn C):   '33333333-3333-3333-3333-333333333333'
   ============================================================================ */
PRINT 'Appending new grades into dbo.grade...';

-- Chỉ chèn nếu tổ hợp (sinh viên, môn học) này chưa tồn tại trong DB để tránh lỗi Unique/PK
-- Sinh viên 1 (Nguyễn Văn A)
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '11111111-1111-1111-1111-111111111111' AND course_id = '44444444-4444-4444-4444-444444444401')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 9.00);
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '11111111-1111-1111-1111-111111111111' AND course_id = '44444444-4444-4444-4444-444444444402')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 8.50);
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '11111111-1111-1111-1111-111111111111' AND course_id = '44444444-4444-4444-4444-444444444501')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), 9.20);

-- Sinh viên 2 (Trần Thị B - Có môn F cần trả nợ hoặc cải thiện)
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '22222222-2222-2222-2222-222222222222' AND course_id = '44444444-4444-4444-4444-444444444401')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 3.00); -- Tạch IT101
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '22222222-2222-2222-2222-222222222222' AND course_id = '44444444-4444-4444-4444-444444444403')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 2.50); -- Tạch IT103
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '22222222-2222-2222-2222-222222222222' AND course_id = '44444444-4444-4444-4444-444444444402')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 5.50); -- Điểm thấp muốn học cải thiện

-- Sinh viên 3 (Phạm Văn C)
IF NOT EXISTS (SELECT 1 FROM dbo.grade WHERE student_id = '33333333-3333-3333-3333-333333333333' AND course_id = '44444444-4444-4444-4444-444444444405')
    INSERT INTO dbo.grade (id, student_id, course_id, grade) VALUES (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), 4.00); -- Tạch môn BA102

-- Điền thêm các dòng điểm đa dạng cho đủ chỉ tiêu 20 bản ghi mới
DECLARE @GradeCounter INT = 1;
WHILE @GradeCounter <= 14
    BEGIN
        INSERT INTO dbo.grade (id, student_id, course_id, grade)
        VALUES (
                   NEWID(),
                   CASE WHEN @GradeCounter % 2 = 0 THEN CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER) ELSE CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER) END,
                   CAST('44444444-4444-4444-4444-444444444701' AS UNIQUEIDENTIFIER),
                   7.00 + (@GradeCounter * 0.1)
               );
        SET @GradeCounter = @GradeCounter + 1;
    END;
GO


/* ============================================================================
   4. BẢNG ĐIỂM CHI TIẾT THEO HỌC KỲ (student_grades) - Thêm 20 dòng học kỳ liên tiếp
   ============================================================================ */
PRINT 'Appending new records into dbo.student_grades...';

-- Thêm tiến trình điểm qua 4 học kỳ của 3 sinh viên
INSERT INTO dbo.student_grades (id, student_id, course_id, semester_id, score, status) VALUES
-- Sinh viên A
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 9.00, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 8.50, N'PASSED'),
(NEWID(), CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 9.20, N'PASSED'),
-- Sinh viên B
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 3.00, N'FAILED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), 2.50, N'FAILED'),
(NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 5.50, N'PASSED'),
-- Sinh viên C
(NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), 4.00, N'FAILED');

-- Vòng lặp bổ sung tiếp các dòng còn lại cho đủ chỉ tiêu 20 bản ghi kiểm thử
DECLARE @StGradeCounter INT = 1;
WHILE @StGradeCounter <= 13
    BEGIN
        INSERT INTO dbo.student_grades (id, student_id, course_id, semester_id, score, status)
        VALUES (
                   NEWID(),
                   CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER),
                   CAST('44444444-4444-4444-4444-444444444601' AS UNIQUEIDENTIFIER),
                   CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER),
                   6.50,
                   N'PASSED'
               );
        SET @StGradeCounter = @StGradeCounter + 1;
    END;
GO


/* ============================================================================
   5. MỞ LỚP HỌC PHẦN (course_offerings) - Thêm lớp mới cho kỳ hiện hành
   ============================================================================ */
PRINT 'Appending classes into course_offerings...';

INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id) VALUES
-- Mở thêm lớp thay thế / tương đương ngoài các lớp đã có
(NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'Kỹ thuật lập trình (Lớp thay thế IT101)', 3.0, 40, 40, NULL),
(NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'Quản trị cơ sở dữ liệu (Lớp tương đương IT103)', 3.0, 35, 35, NULL),
(NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'Chiến lược Marketing (Lớp thay thế BA102)', 4.0, 50, 50, NULL);

-- Nạp thêm 17 dòng lớp học phần ngẫu nhiên cho đợt Ngoại Ngữ để phục vụ kiểm thử phân trang
DECLARE @OfferingCounter INT = 1;
WHILE @OfferingCounter <= 17
    BEGIN
        INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
        VALUES (
                   NEWID(),
                   CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER),
                   CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER),
                   N'Tiếng Anh nâng cao - Class ' + CAST(@OfferingCounter AS NVARCHAR(2)),
                   3.0, 30, 30, NULL
               );
        SET @OfferingCounter = @OfferingCounter + 1;
    END;
GO

-- ============================================================================
-- FIXED SEED CODE FOR course_registrations (MATCHING JAVA ENTITY DEFINITION)
-- ============================================================================

PRINT 'Appending data into course_registrations (Entity-aligned version)...';

-- 1. Đăng ký cho Trần Thị B ('22222222-2222-2222-2222-222222222222')
-- Môn thứ nhất: IT101X (Học lại thay thế môn IT101) thuộc Đợt học lại CNTT K23 ('55555555-5555-5555-5555-555555555501')
INSERT INTO dbo.course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, status, is_paid, created_at, registered_at)
SELECT TOP 1
    NEWID(),
    CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
    id, -- mapping sang course_class_id
    CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER),
    2,  -- registration_type = 2 (Học lại)
    1,  -- status = 1 (Thành công)
    1,  -- is_paid = true
    GETDATE(),
    GETDATE()
FROM dbo.course_offerings
WHERE course_id = CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER);

-- Môn thứ hai: IT103Alt (Học lại tương đương môn IT103) thuộc Đợt học lại CNTT K23
INSERT INTO dbo.course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, status, is_paid, created_at, registered_at)
SELECT TOP 1
    NEWID(),
    CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
    id,
    CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER),
    2,  -- registration_type = 2 (Học lại)
    1,  -- status = 1
    1,
    GETDATE(),
    GETDATE()
FROM dbo.course_offerings
WHERE course_id = CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER);


-- 2. Đăng ký cho Phạm Văn C ('33333333-3333-3333-3333-333333333333')
-- Môn: BA102X (Môn học lại thay thế) thuộc Đợt đăng ký QTKD (All) ('55555555-5555-5555-5555-555555555503')
INSERT INTO dbo.course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, status, is_paid, created_at, registered_at)
SELECT TOP 1
    NEWID(),
    CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER),
    id,
    CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER),
    2,  -- registration_type = 2 (Học lại)
    1,  -- status = 1
    1,
    GETDATE(),
    GETDATE()
FROM dbo.course_offerings
WHERE course_id = CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER);


-- 3. Nạp thêm 17 dòng đăng ký phụ cho Sinh viên A ('11111111-1111-1111-1111-111111111111')
-- Đăng ký vào môn Mạng máy tính IT202 (Mở mới hoàn toàn) thuộc Đợt chính thức CNTT K24 ('55555555-5555-5555-5555-555555555502')
DECLARE @RegCounter INT = 1;
DECLARE @TargetOfferingId UNIQUEIDENTIFIER;

-- Trích xuất id lớp học phần thực tế đang mở cho môn IT202
SELECT TOP 1 @TargetOfferingId = id
FROM dbo.course_offerings
WHERE course_id = CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER);

IF @TargetOfferingId IS NOT NULL
    BEGIN
        WHILE @RegCounter <= 17
            BEGIN
                INSERT INTO dbo.course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, status, is_paid, created_at, registered_at)
                VALUES (
                           NEWID(),
                           CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER),
                           @TargetOfferingId,
                           CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER),
                           1,  -- registration_type = 1 (Học mới)
                           1,  -- status = 1 (Thành công)
                           1,  -- is_paid = true
                           GETDATE(),
                           GETDATE()
                       );
                SET @RegCounter = @RegCounter + 1;
            END;
        PRINT 'Successfully added 17 telemetry registration rows for student A.';
    END
ELSE
    BEGIN
        PRINT 'Warning: Missing course offering definition for IT202. Loop seed aborted.';
    END;
GO
/* ============================================================================
   7. ĐƠN ĐĂNG KÝ ĐẶC CÁCH (registration_requests) - Thêm 20 đơn mới
   ============================================================================ */
PRINT 'Appending data into registration_requests...';

-- Thêm các yêu cầu đặc cách liên quan đến môn học thay thế/tương đương
INSERT INTO dbo.registration_requests
(id, student_id, student_code, student_name, email, cohort, major, faculty, request_type, desired_course_id, desired_course_name, target_faculty, target_cohort, target_semester, reason, status, created_at)
VALUES
    (NEWID(), CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin', N'EQUIVALENT_COURSE', CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'Kỹ thuật lập trình (Môn thay thế IT101)', N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)', N'Em xin đăng ký môn học thay thế IT101X do môn gốc IT101 đã dừng giảng dạy.', N'APPROVED', GETDATE()),
    (NEWID(), CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), N'SV_QTKD_K24_01', N'Phạm Văn C', N'phamvanc@demo.edu', N'K24', N'Marketing', N'Quản trị kinh doanh', N'EQUIVALENT_COURSE', CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'Chiến lược Marketing (Môn thay thế BA102)', N'Quản trị kinh doanh', N'K24', N'Học kỳ 1 (2024-2025)', N'Đăng ký môn thay thế tích lũy điểm do trượt môn cũ.', N'PENDING', GETDATE());

-- Tạo vòng lặp sinh thêm 18 đơn yêu cầu nữa để đủ 20 bản ghi test logic phân trang (Pagination)
DECLARE @ReqCounter INT = 1;
WHILE @ReqCounter <= 18
    BEGIN
        INSERT INTO dbo.registration_requests
        (id, student_id, student_code, student_name, email, cohort, major, faculty, request_type, desired_course_id, desired_course_name, target_faculty, target_cohort, target_semester, reason, status, created_at)
        VALUES (
                   NEWID(),
                   CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER),
                   N'SV_CNTT_K23_01', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin',
                   N'OPEN_CLASS', CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'Hệ điều hành', N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)',
                   N'Xin mở thêm slot lớp học phần bổ trợ số ' + CAST(@ReqCounter AS NVARCHAR(2)), N'PENDING', GETDATE()
               );
        SET @ReqCounter = @ReqCounter + 1;
    END;
GO

PRINT '===========================================================';
PRINT 'APPEND-ONLY SEED SCRIPT EXECUTED SUCCESSFULLY!';
PRINT 'All new records added. No existing database rows were harmed.';
PRINT '===========================================================';






-- ============================================================================
-- FIXED EXTENDED SEED (COMPATIBLE WITH NEW ENTITY DEFINITIONS)
-- Target System: SQL Server / T-SQL (APPEND ONLY)
-- Strict Control: TINYINT for credits limits & INT for course credits
-- ============================================================================

SET NOCOUNT ON;
GO

/* ============================================================================
   1. ĐỒNG BỘ DATA PROFILE CHO 3 SINH VIÊN (Mã MSV: ten00000X)
   ============================================================================ */
PRINT 'Updating/Inserting Student Profiles with exact Ten00000X format...';

-- Sinh viên 1: Nguyễn Văn A -> anvana000001
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_id = CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER))
    BEGIN
        INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
        VALUES (CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER), N'anvana000001', N'Nguyễn Văn A', N'nguyenvana@demo.edu', N'K24', N'Kỹ thuật phần mềm', N'Công nghệ thông tin');
    END
ELSE
    BEGIN
        UPDATE dbo.student_profiles
        SET student_code = N'anvana000001', student_name = N'Nguyễn Văn A'
        WHERE student_id = CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER);
    END;

-- Sinh viên 2: Trần Thị B -> bthi000002
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_id = CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER))
    BEGIN
        INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
        VALUES (CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER), N'bthi000002', N'Trần Thị B', N'tranthib@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin');
    END
ELSE
    BEGIN
        UPDATE dbo.student_profiles
        SET student_code = N'bthi000002', student_name = N'Trần Thị B'
        WHERE student_id = CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER);
    END;

-- Sinh viên 3: Phạm Văn C -> cvan000003
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_id = CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER))
    BEGIN
        INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
        VALUES (CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER), N'cvan000003', N'Phạm Văn C', N'phamvanc@demo.edu', N'K24', N'Marketing', N'Quản trị kinh doanh');
    END
ELSE
    BEGIN
        UPDATE dbo.student_profiles
        SET student_code = N'cvan000003', student_name = N'Phạm Văn C'
        WHERE student_id = CAST('33333333-3333-3333-3333-333333333333' AS UNIQUEIDENTIFIER);
    END;
GO


/* ============================================================================
   2. BỔ SUNG NHIỀU ĐỢT ĐĂNG KÝ (registration_periods) - ÉP KIỂU TINYINT
   ============================================================================ */
PRINT 'Appending multiple registration periods (TINYINT safe)...';

-- Đợt bổ sung HK1 (2023-2024)
IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = '55555555-5555-5555-5555-555555555511')
    INSERT INTO dbo.registration_periods (id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
    VALUES (CAST('55555555-5555-5555-5555-555555555511' AS UNIQUEIDENTIFIER), N'Đợt bổ sung học kỳ 1 (2023-2024) - Toàn trường', CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), '2023-09-10 08:00:00', '2023-09-20 17:00:00', N'{"allowRetake":true}', 20, 0, 1, 1, GETDATE());

-- Đợt chính thức HK2 (2023-2024)
IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = '55555555-5555-5555-5555-555555555512')
    INSERT INTO dbo.registration_periods (id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
    VALUES (CAST('55555555-5555-5555-5555-555555555512' AS UNIQUEIDENTIFIER), N'Đợt đăng ký chính thức HK2 (2023-2024) - Khối K23', CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), '2024-02-01 00:00:00', '2024-02-14 23:59:59', N'{"cohorts":["K23"]}', 25, 12, 0, 1, GETDATE());

-- Đợt vét hè khóa 2023
IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = '55555555-5555-5555-5555-555555555513')
    INSERT INTO dbo.registration_periods (id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
    VALUES (CAST('55555555-5555-5555-5555-555555555513' AS UNIQUEIDENTIFIER), N'Đợt đăng ký vét / Học lại hè khóa cũ 2023', CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), '2024-06-01 08:00:00', '2024-06-10 17:00:00', N'{"allowRetake":true,"allowImprove":true}', 15, 0, 1, 1, GETDATE());

-- Đợt tăng hạn mức HK1 (2024-2025)
IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = '55555555-5555-5555-5555-555555555514')
    INSERT INTO dbo.registration_periods (id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
    VALUES (CAST('55555555-5555-5555-5555-555555555514' AS UNIQUEIDENTIFIER), N'Đợt đăng ký tăng cường HK1 (2024-2025)', CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, 8, GETDATE()), N'{"allowOverCredit":true}', 28, 12, 1, 1, GETDATE());


-- Vòng lặp tự động nạp thêm 15 đợt đăng ký khác (đảm bảo tổng lượng >20 dòng để test Pagination)
DECLARE @PeriodLoop INT = 1;
WHILE @PeriodLoop <= 15
    BEGIN
        DECLARE @DynamicUUID NVARCHAR(50) = '55555555-5555-5555-5555-555555555' + RIGHT('000' + CAST(@PeriodLoop + 20 AS NVARCHAR(3)), 3);

        IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = CAST(@DynamicUUID AS UNIQUEIDENTIFIER))
            BEGIN
                INSERT INTO dbo.registration_periods (id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
                VALUES (
                           CAST(@DynamicUUID AS UNIQUEIDENTIFIER),
                           N'Đợt đăng ký chuyên đề mở rộng loại ' + CAST(@PeriodLoop AS NVARCHAR(2)),
                           CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER),
                           DATEADD(DAY, @PeriodLoop, GETDATE()),
                           DATEADD(DAY, @PeriodLoop + 5, GETDATE()),
                           N'{"allowFreeRegistration":true}',
                           25, -- Khớp TINYINT
                           10, -- Khớp TINYINT
                           1, 1, GETDATE()
                       );
            END;
        SET @PeriodLoop = @PeriodLoop + 1;
    END;
GO


/* ============================================================================
   3. MỞ NHIỀU LỚP HỌC PHẦN (course_offerings) CHO CÁC ĐỢT MỚI TẠO Ở TRÊN
   Strict Control: credits chèn kiểu số nguyên (INT) thay vì số thực
   ============================================================================ */
PRINT 'Appending diverse course_offerings matching new periods (Integer credits safe)...';

-- Gán lớp vào Đợt bổ sung HK1 2023 ('55555555-5555-5555-5555-555555555511')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots) VALUES
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555511' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444591' AS UNIQUEIDENTIFIER), N'Kỹ thuật lập trình (Môn thay thế IT101)', 3, 50, 50),
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555511' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444592' AS UNIQUEIDENTIFIER), N'Quản trị cơ sở dữ liệu (Tương đương IT103)', 3, 40, 40);

-- Gán lớp vào Đợt chính thức HK2 2023 ('55555555-5555-5555-5555-555555555512')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots) VALUES
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555512' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444501' AS UNIQUEIDENTIFIER), N'Hệ điều hành nhóm 1', 3, 60, 60),
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555512' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444502' AS UNIQUEIDENTIFIER), N'Mạng máy tính nhóm 1', 3, 55, 55);

-- Gán lớp vào Đợt tăng cường HK1 2024 ('55555555-5555-5555-5555-555555555514')
INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots) VALUES
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555514' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444503' AS UNIQUEIDENTIFIER), N'Phân tích thiết kế hệ thống nâng cao', 4, 45, 45),
                                                                                                                               (NEWID(), CAST('55555555-5555-5555-5555-555555555514' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444691' AS UNIQUEIDENTIFIER), N'Chiến lược Marketing (Môn thay thế BA102)', 4, 50, 50);

-- Dùng vòng lặp phân phối thêm 15 lớp học phần trải dài qua các Đợt tự chọn vừa tạo tự động ở trên
DECLARE @OfferLoop INT = 1;
WHILE @OfferLoop <= 15
    BEGIN
        DECLARE @TargetPeriodUUID NVARCHAR(50) = '55555555-5555-5555-5555-555555555' + RIGHT('000' + CAST(@OfferLoop + 20 AS NVARCHAR(3)), 3);

        INSERT INTO dbo.course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots)
        VALUES (
                   NEWID(),
                   CAST(@TargetPeriodUUID AS UNIQUEIDENTIFIER),
                   CAST('44444444-4444-4444-4444-444444444702' AS UNIQUEIDENTIFIER), -- Môn tiếng Anh nâng cao EN202
                   N'Tiếng Anh bổ trợ giao tiếp lớp ' + CAST(@OfferLoop AS NVARCHAR(2)),
                   3, -- Integer type safe
                   30,
                   30
               );
        SET @OfferLoop = @OfferLoop + 1;
    END;
GO

PRINT '===========================================================';
PRINT 'SUCCESSFULLY SYNCHRONIZED AND APPLICABLE FOR TEST PHASES!';
PRINT '===========================================================';