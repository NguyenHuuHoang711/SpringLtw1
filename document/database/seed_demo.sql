-- ============================================================================
-- EXTENDED DEMO SEED FOR REGISTRATION & RETAKE LOGIC TESTING
-- Scope:
--   - 3 Faculties
--   - 2 Cohorts per faculty (K23, K24)
--   - 4 consecutive semesters
--   - 9+ courses with diverse credits (2, 3, 4)
--   - course offerings with some fixed-year, some free-open (NULL academic_year_id)
--   - 5 student types:
--       A: excellent
--       B: debt/retake required
--       C: improvement
--       D: cross-faculty
--       E: new student
-- Compatible with SQL Server + native JDBC execution (GO batches)
-- ============================================================================

SET NOCOUNT ON;
GO

/* ============================================================================
   0. CLEAN UP (child tables first)
   ============================================================================ */
IF OBJECT_ID('dbo.registration_requests', 'U') IS NOT NULL DELETE FROM dbo.registration_requests;
GO
IF OBJECT_ID('dbo.student_grades', 'U') IS NOT NULL DELETE FROM dbo.student_grades;
GO
IF OBJECT_ID('dbo.course_offerings', 'U') IS NOT NULL DELETE FROM dbo.course_offerings;
GO
IF OBJECT_ID('dbo.course_registrations', 'U') IS NOT NULL DELETE FROM dbo.course_registrations;
GO
IF OBJECT_ID('dbo.registration_periods', 'U') IS NOT NULL DELETE FROM dbo.registration_periods;
GO
IF OBJECT_ID('dbo.student_profiles', 'U') IS NOT NULL DELETE FROM dbo.student_profiles;
GO
IF OBJECT_ID('dbo.academic_years', 'U') IS NOT NULL DELETE FROM dbo.academic_years;
GO
IF OBJECT_ID('dbo.courses', 'U') IS NOT NULL DELETE FROM dbo.courses;
GO
IF OBJECT_ID('dbo.semesters', 'U') IS NOT NULL DELETE FROM dbo.semesters;
GO

/* ============================================================================
   1. CREATE TABLES IF MISSING
   ============================================================================ */
IF OBJECT_ID('dbo.semesters', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.semesters (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		code NVARCHAR(50) NOT NULL,
		name NVARCHAR(100) NOT NULL,
		start_date DATE NULL,
		end_date DATE NULL
	);
END
GO

IF OBJECT_ID('dbo.academic_years', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.academic_years (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		code NVARCHAR(50) NULL,
		name NVARCHAR(100) NOT NULL,
		is_active BIT NULL,
		created_at DATETIME2 NULL
	);
END
GO

IF COL_LENGTH('dbo.academic_years', 'code') IS NULL
	ALTER TABLE dbo.academic_years ADD code NVARCHAR(50) NULL;
GO
IF COL_LENGTH('dbo.academic_years', 'is_active') IS NULL
	ALTER TABLE dbo.academic_years ADD is_active BIT NULL;
GO
IF COL_LENGTH('dbo.academic_years', 'created_at') IS NULL
	ALTER TABLE dbo.academic_years ADD created_at DATETIME2 NULL;
GO

IF OBJECT_ID('dbo.student_profiles', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.student_profiles (
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

IF OBJECT_ID('dbo.courses', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.courses (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		code NVARCHAR(50) NOT NULL,
		name NVARCHAR(200) NOT NULL,
		name_en NVARCHAR(200) NULL,
		credits DECIMAL(4,1) NOT NULL,
		theory_hours DECIMAL(5,1) NULL,
		practice_hours DECIMAL(5,1) NULL,
		self_study_hours DECIMAL(5,1) NULL,
		is_active BIT NOT NULL DEFAULT 1,
		created_at DATETIME2 NOT NULL DEFAULT GETDATE()
	);
END
GO

IF OBJECT_ID('dbo.registration_periods', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.registration_periods (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		name NVARCHAR(150) NOT NULL,
		semester_id UNIQUEIDENTIFIER NOT NULL,
		start_time DATETIME2 NOT NULL,
		end_time DATETIME2 NOT NULL,
		target_config NVARCHAR(MAX) NULL,
		max_credits INT NULL,
		min_credits INT NULL,
		allow_retake BIT NOT NULL DEFAULT 0,
		is_active BIT NOT NULL DEFAULT 1,
		created_at DATETIME2 NOT NULL DEFAULT GETDATE()
	);
END
GO

IF OBJECT_ID('dbo.course_offerings', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.course_offerings (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		registration_period_id UNIQUEIDENTIFIER NOT NULL,
		course_id UNIQUEIDENTIFIER NOT NULL,
		course_name NVARCHAR(255) NOT NULL,
		credits DECIMAL(4,1) NOT NULL,
		available_slots INT NOT NULL,
		max_slots INT NOT NULL
	);
END
GO

IF COL_LENGTH('dbo.course_offerings', 'academic_year_id') IS NULL
	ALTER TABLE dbo.course_offerings ADD academic_year_id UNIQUEIDENTIFIER NULL;
GO

IF OBJECT_ID('dbo.student_grades', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.student_grades (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		student_id UNIQUEIDENTIFIER NOT NULL,
		course_id UNIQUEIDENTIFIER NOT NULL,
		semester_id UNIQUEIDENTIFIER NOT NULL,
		score DECIMAL(4,2) NOT NULL,
		status NVARCHAR(20) NOT NULL
	);
END
GO

IF OBJECT_ID('dbo.grade', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.grade (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		student_id UNIQUEIDENTIFIER NOT NULL,
		course_id UNIQUEIDENTIFIER NOT NULL,
		grade DECIMAL(4,2) NOT NULL
	);
END
GO

IF OBJECT_ID('dbo.registration_requests', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.registration_requests (
		id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
		student_id UNIQUEIDENTIFIER NOT NULL,
		student_code NVARCHAR(50) NULL,
		student_name NVARCHAR(100) NULL,
		email NVARCHAR(100) NULL,
		cohort NVARCHAR(50) NULL,
		major NVARCHAR(100) NULL,
		faculty NVARCHAR(100) NULL,
		request_type NVARCHAR(30) NOT NULL,
		desired_course_id UNIQUEIDENTIFIER NULL,
		desired_course_name NVARCHAR(255) NULL,
		target_faculty NVARCHAR(100) NULL,
		target_cohort NVARCHAR(50) NULL,
		target_semester NVARCHAR(100) NULL,
		reason NVARCHAR(MAX) NOT NULL,
		status NVARCHAR(20) NOT NULL,
		admin_note NVARCHAR(MAX) NULL,
		created_at DATETIME2 NOT NULL,
		reviewed_at DATETIME2 NULL
	);
END
GO

/* ============================================================================
   2. SEMESTERS
   ============================================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.semesters WHERE code = N'HK1_2023')
INSERT INTO dbo.semesters (id, code, name, start_date, end_date)
VALUES (CAST('11111111-1111-1111-1111-111111111101' AS UNIQUEIDENTIFIER), N'HK1_2023', N'Học kỳ 1 (2023-2024)', '2023-09-05', '2024-01-15');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.semesters WHERE code = N'HK2_2023')
INSERT INTO dbo.semesters (id, code, name, start_date, end_date)
VALUES (CAST('11111111-1111-1111-1111-111111111102' AS UNIQUEIDENTIFIER), N'HK2_2023', N'Học kỳ 2 (2023-2024)', '2024-02-15', '2024-06-30');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.semesters WHERE code = N'HK1_2024')
INSERT INTO dbo.semesters (id, code, name, start_date, end_date)
VALUES (CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER), N'HK1_2024', N'Học kỳ 1 (2024-2025)', '2024-09-05', '2025-01-15');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.semesters WHERE code = N'HK2_2024')
INSERT INTO dbo.semesters (id, code, name, start_date, end_date)
VALUES (CAST('11111111-1111-1111-1111-111111111104' AS UNIQUEIDENTIFIER), N'HK2_2024', N'Học kỳ 2 (2024-2025)', '2025-02-15', '2025-06-30');
GO

/* ============================================================================
   3. ACADEMIC YEARS / COHORTS
   ============================================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222201' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222201' AS UNIQUEIDENTIFIER), N'K23_CNTT', N'CNTT - K23', 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER), N'K24_CNTT', N'CNTT - K24', 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222203' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222203' AS UNIQUEIDENTIFIER), N'K23_QTKD', N'QTKD - K23', 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222204' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222204' AS UNIQUEIDENTIFIER), N'K24_QTKD', N'QTKD - K24', 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222205' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222205' AS UNIQUEIDENTIFIER), N'K23_EN', N'NGOẠI NGỮ - K23', 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.academic_years WHERE id = CAST('22222222-2222-2222-2222-222222222206' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.academic_years (id, code, name, is_active, created_at)
VALUES (CAST('22222222-2222-2222-2222-222222222206' AS UNIQUEIDENTIFIER), N'K24_EN', N'NGOẠI NGỮ - K24', 1, GETDATE());
GO

/* ============================================================================
   4. STUDENTS (A-E)
   ============================================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_code = N'SV_IT23_A1')
INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
VALUES (CAST('33333333-3333-3333-3333-333333333301' AS UNIQUEIDENTIFIER), N'SV_IT23_A1', N'Lê Minh Cường', N'leminhcuong@demo.edu', N'K23', N'Kỹ thuật phần mềm', N'Công nghệ thông tin');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_code = N'SV_IT23_B1')
INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
VALUES (CAST('33333333-3333-3333-3333-333333333302' AS UNIQUEIDENTIFIER), N'SV_IT23_B1', N'Trần Đại Nghĩa', N'trandainghia@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_code = N'SV_IT23_C1')
INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
VALUES (CAST('33333333-3333-3333-3333-333333333303' AS UNIQUEIDENTIFIER), N'SV_IT23_C1', N'Phạm Tuấn Khang', N'phamtuankhang@demo.edu', N'K23', N'Trí tuệ nhân tạo', N'Công nghệ thông tin');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_code = N'SV_BA23_D1')
INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
VALUES (CAST('33333333-3333-3333-3333-333333333304' AS UNIQUEIDENTIFIER), N'SV_BA23_D1', N'Nguyễn Thị Lan', N'nguyenthilan@demo.edu', N'K23', N'Marketing', N'Quản trị kinh doanh');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.student_profiles WHERE student_code = N'SV_EN24_E1')
INSERT INTO dbo.student_profiles (student_id, student_code, student_name, email, cohort, major, faculty)
VALUES (CAST('33333333-3333-3333-3333-333333333305' AS UNIQUEIDENTIFIER), N'SV_EN24_E1', N'Vũ Phương Thảo', N'vuphuongthao@demo.edu', N'K24', N'Ngôn ngữ Anh', N'Ngoại ngữ');
GO

/* ============================================================================
   5. COURSES (3 faculties, 9+ courses, 2/3/4 credits)
   ============================================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'IT101')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), N'IT101', N'Nhập môn Lập trình', N'Introduction to Programming', 3.0, 30, 15, 45, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'IT102')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), N'IT102', N'Cấu trúc dữ liệu và Giải thuật', N'Data Structures and Algorithms', 4.0, 45, 30, 60, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'IT103')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), N'IT103', N'Cơ sở dữ liệu', N'Database Systems', 3.0, 30, 15, 45, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'BA101')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), N'BA101', N'Kinh tế vi mô', N'Microeconomics', 3.0, 30, 15, 45, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'BA102')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), N'BA102', N'Marketing căn bản', N'Principles of Marketing', 4.0, 45, 15, 60, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'BA103')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444406' AS UNIQUEIDENTIFIER), N'BA103', N'Quản trị nhân sự', N'Human Resource Management', 2.0, 20, 10, 30, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'EN101')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), N'EN101', N'Tiếng Anh giao tiếp 1', N'English Communication 1', 2.0, 20, 20, 20, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'EN102')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444408' AS UNIQUEIDENTIFIER), N'EN102', N'Tiếng Anh giao tiếp 2', N'English Communication 2', 2.0, 20, 20, 20, 1, GETDATE());
GO
IF NOT EXISTS (SELECT 1 FROM dbo.courses WHERE code = N'EN103')
INSERT INTO dbo.courses (id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES (CAST('44444444-4444-4444-4444-444444444409' AS UNIQUEIDENTIFIER), N'EN103', N'Tiếng Anh chuyên ngành', N'English for Specific Purposes', 3.0, 30, 15, 45, 1, GETDATE());
GO

/* ============================================================================
   6. GRADE HISTORY FOR 3 DEMO STUDENTS
   - Uses dbo.grade because the current Grade entity maps to table `grade`
   - Keep 3 students with multiple grades for retake / improvement demos
   ============================================================================ */
INSERT INTO dbo.grade (id, student_id, course_id, grade)
VALUES
(NEWID(), CAST('33333333-3333-3333-3333-333333333301' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 8.50),
(NEWID(), CAST('33333333-3333-3333-3333-333333333301' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 9.00),
(NEWID(), CAST('33333333-3333-3333-3333-333333333301' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 8.75),
(NEWID(), CAST('33333333-3333-3333-3333-333333333302' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 3.50),
(NEWID(), CAST('33333333-3333-3333-3333-333333333302' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 2.75),
(NEWID(), CAST('33333333-3333-3333-3333-333333333302' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 5.50),
(NEWID(), CAST('33333333-3333-3333-3333-333333333303' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), 5.80),
(NEWID(), CAST('33333333-3333-3333-3333-333333333303' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), 6.00),
(NEWID(), CAST('33333333-3333-3333-3333-333333333303' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), 5.25);
GO

/* ============================================================================
   7. REGISTRATION PERIODS
   ============================================================================ */
IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.registration_periods
(id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES
(CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER),
 N'Đợt học lại CNTT K23',
 CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER),
 DATEADD(DAY, -2, GETDATE()),
 DATEADD(DAY, 10, GETDATE()),
 N'{"faculties":["Công nghệ thông tin"],"cohorts":["K23"],"allowRetake":true,"allowImprove":true}',
 15, 0, 1, 1, GETDATE());
GO

IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.registration_periods
(id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES
(CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER),
 N'Đợt chính thức CNTT K24',
 CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER),
 DATEADD(DAY, -2, GETDATE()),
 DATEADD(DAY, 10, GETDATE()),
 N'{"faculties":["Công nghệ thông tin"],"cohorts":["K24"]}',
 25, 10, 0, 1, GETDATE());
GO

IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.registration_periods
(id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES
(CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER),
 N'Đợt đăng ký QTKD (All)',
 CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER),
 DATEADD(DAY, -2, GETDATE()),
 DATEADD(DAY, 10, GETDATE()),
 N'{"faculties":["Quản trị kinh doanh"],"cohorts":["K23","K24"]}',
 25, 10, 1, 1, GETDATE());
GO

IF NOT EXISTS (SELECT 1 FROM dbo.registration_periods WHERE id = CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER))
INSERT INTO dbo.registration_periods
(id, name, semester_id, start_time, end_time, target_config, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES
(CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER),
 N'Đợt đăng ký Ngoại ngữ',
 CAST('11111111-1111-1111-1111-111111111103' AS UNIQUEIDENTIFIER),
 DATEADD(DAY, -2, GETDATE()),
 DATEADD(DAY, 10, GETDATE()),
 N'{"faculties":["Ngoại ngữ"],"cohorts":["K23","K24"]}',
 20, 8, 1, 1, GETDATE());
GO

/* ============================================================================
   8. COURSE OFFERINGS
   - fixed-year offerings: academic_year_id specific
   - free-open offerings: academic_year_id NULL
   ============================================================================ */
INSERT INTO dbo.course_offerings
(id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
VALUES
(NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), N'Nhập môn Lập trình (K24)', 3.0, 50, 50, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444403' AS UNIQUEIDENTIFIER), N'Cơ sở dữ liệu (K24)', 3.0, 40, 40, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555502' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), N'Cấu trúc dữ liệu và Giải thuật (K24)', 4.0, 0, 40, CAST('22222222-2222-2222-2222-222222222202' AS UNIQUEIDENTIFIER));
GO

INSERT INTO dbo.course_offerings
(id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
VALUES
(NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), N'Nhập môn Lập trình - Học lại', 3.0, 30, 30, NULL),
(NEWID(), CAST('55555555-5555-5555-5555-555555555501' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), N'Cấu trúc dữ liệu và Giải thuật - Cải thiện', 4.0, 20, 20, NULL);
GO

INSERT INTO dbo.course_offerings
(id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
VALUES
(NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444404' AS UNIQUEIDENTIFIER), N'Kinh tế vi mô (QTKD)', 3.0, 60, 60, CAST('22222222-2222-2222-2222-222222222204' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444405' AS UNIQUEIDENTIFIER), N'Marketing căn bản (QTKD)', 4.0, 0, 60, CAST('22222222-2222-2222-2222-222222222204' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555503' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444406' AS UNIQUEIDENTIFIER), N'Quản trị nhân sự (QTKD)', 2.0, 18, 20, CAST('22222222-2222-2222-2222-222222222204' AS UNIQUEIDENTIFIER));
GO

INSERT INTO dbo.course_offerings
(id, registration_period_id, course_id, course_name, credits, available_slots, max_slots, academic_year_id)
VALUES
(NEWID(), CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), N'Tiếng Anh giao tiếp 1', 2.0, 25, 25, CAST('22222222-2222-2222-2222-222222222206' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444408' AS UNIQUEIDENTIFIER), N'Tiếng Anh giao tiếp 2', 2.0, 0, 25, CAST('22222222-2222-2222-2222-222222222206' AS UNIQUEIDENTIFIER)),
(NEWID(), CAST('55555555-5555-5555-5555-555555555504' AS UNIQUEIDENTIFIER), CAST('44444444-4444-4444-4444-444444444409' AS UNIQUEIDENTIFIER), N'Tiếng Anh chuyên ngành', 3.0, 15, 20, NULL);
GO

/* ============================================================================
   9. SAMPLE REGISTRATION REQUESTS
   ============================================================================ */
INSERT INTO dbo.registration_requests
(id, student_id, student_code, student_name, email, cohort, major, faculty, request_type,
 desired_course_id, desired_course_name, target_faculty, target_cohort, target_semester,
 reason, status, admin_note, created_at, reviewed_at)
VALUES
(NEWID(), CAST('33333333-3333-3333-3333-333333333302' AS UNIQUEIDENTIFIER), N'SV_IT23_B1', N'Trần Đại Nghĩa', N'trandainghia@demo.edu', N'K23', N'An toàn thông tin', N'Công nghệ thông tin',
 N'OPEN_CLASS', CAST('44444444-4444-4444-4444-444444444401' AS UNIQUEIDENTIFIER), N'Nhập môn Lập trình',
 N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)',
 N'Lớp học lại bị đầy, em cần đăng ký để trả nợ môn.', N'PENDING', NULL, GETDATE(), NULL),

(NEWID(), CAST('33333333-3333-3333-3333-333333333303' AS UNIQUEIDENTIFIER), N'SV_IT23_C1', N'Phạm Tuấn Khang', N'phamtuankhang@demo.edu', N'K23', N'Trí tuệ nhân tạo', N'Công nghệ thông tin',
 N'OPEN_CLASS', CAST('44444444-4444-4444-4444-444444444402' AS UNIQUEIDENTIFIER), N'Cấu trúc dữ liệu và Giải thuật',
 N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)',
 N'Em đã qua môn nhưng muốn học lại để cải thiện điểm và tích lũy kiến thức.', N'PENDING', NULL, GETDATE(), NULL),

(NEWID(), CAST('33333333-3333-3333-3333-333333333304' AS UNIQUEIDENTIFIER), N'SV_BA23_D1', N'Nguyễn Thị Lan', N'nguyenthilan@demo.edu', N'K23', N'Marketing', N'Quản trị kinh doanh',
 N'CROSS_FACULTY', CAST('44444444-4444-4444-4444-444444444408' AS UNIQUEIDENTIFIER), N'Tiếng Anh giao tiếp 2',
 N'Ngoại ngữ', N'K23', N'Học kỳ 1 (2024-2025)',
 N'Em muốn đăng ký môn chéo khoa để phục vụ chuyên môn marketing quốc tế.', N'APPROVED', N'Đủ điều kiện chéo khoa.', GETDATE(), GETDATE()),

(NEWID(), CAST('33333333-3333-3333-3333-333333333305' AS UNIQUEIDENTIFIER), N'SV_EN24_E1', N'Vũ Phương Thảo', N'vuphuongthao@demo.edu', N'K24', N'Ngôn ngữ Anh', N'Ngoại ngữ',
 N'OPEN_CLASS', CAST('44444444-4444-4444-4444-444444444407' AS UNIQUEIDENTIFIER), N'Tiếng Anh giao tiếp 1',
 N'Ngoại ngữ', N'K24', N'Học kỳ 1 (2024-2025)',
 N'Đây là học kỳ đầu tiên của em, em cần đăng ký học phần nền tảng.', N'PENDING', NULL, GETDATE(), NULL),

(NEWID(), CAST('33333333-3333-3333-3333-333333333301' AS UNIQUEIDENTIFIER), N'SV_IT23_A1', N'Lê Minh Cường', N'leminhcuong@demo.edu', N'K23', N'Kỹ thuật phần mềm', N'Công nghệ thông tin',
 N'OPEN_PERIOD', NULL, NULL,
 N'Công nghệ thông tin', N'K23', N'Học kỳ 1 (2024-2025)',
 N'Em muốn mở thêm đợt đăng ký vì lịch học bị xung đột.', N'PENDING', NULL, GETDATE(), NULL);
GO

-- End of script

