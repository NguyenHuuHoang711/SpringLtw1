-- Simple seed data for demo (compatible with Spring ResourceDatabasePopulator)
-- Uses individual statements ended with semicolon
-- Assumes all tables already created by Hibernate/migrations
-- ============================================================================

-- ===== Insert Departments =====
IF NOT EXISTS (SELECT 1 FROM departments WHERE code = N'CNTT')
INSERT INTO departments (id, code, name) VALUES (NEWID(), N'CNTT', N'Công nghệ thông tin');
GO

IF NOT EXISTS (SELECT 1 FROM departments WHERE code = N'QTKD')
INSERT INTO departments (id, code, name) VALUES (NEWID(), N'QTKD', N'Quản trị kinh doanh');
GO

-- ===== Insert Academic Years =====
IF NOT EXISTS (SELECT 1 FROM academic_years WHERE code = N'K23')
INSERT INTO academic_years (id, code, name) VALUES (NEWID(), N'K23', N'Khóa 2023');
GO

IF NOT EXISTS (SELECT 1 FROM academic_years WHERE code = N'K24')
INSERT INTO academic_years (id, code, name) VALUES (NEWID(), N'K24', N'Khóa 2024');
GO

-- ===== Insert School Years =====
IF NOT EXISTS (SELECT 1 FROM school_years WHERE name = N'Năm học 2024-2025')
INSERT INTO school_years (id, name, academic_year_id)
SELECT NEWID(), N'Năm học 2024-2025', id FROM academic_years WHERE code = N'K24';
GO

-- ===== Insert Semesters =====
IF NOT EXISTS (SELECT 1 FROM semesters WHERE code = N'HK1_2024')
INSERT INTO semesters (id, code, name, school_year_id)
SELECT NEWID(), N'HK1_2024', N'Học kỳ 1', id FROM school_years WHERE name = N'Năm học 2024-2025';
GO

-- ===== Insert Student Profiles =====
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

-- ===== Insert Sample Students =====
IF NOT EXISTS (SELECT 1 FROM students WHERE email = N'nguyenvana@demo.edu')
INSERT INTO students (id, name, email) VALUES (NEWID(), N'Nguyễn Văn A', N'nguyenvana@demo.edu');
GO

IF NOT EXISTS (SELECT 1 FROM students WHERE email = N'tranthib@demo.edu')
INSERT INTO students (id, name, email) VALUES (NEWID(), N'Trần Thị B', N'tranthib@demo.edu');
GO

IF NOT EXISTS (SELECT 1 FROM students WHERE email = N'phamvanc@demo.edu')
INSERT INTO students (id, name, email) VALUES (NEWID(), N'Phạm Văn C', N'phamvanc@demo.edu');
GO

-- ===== Insert Sample Courses (if not exist) =====
IF NOT EXISTS (SELECT 1 FROM courses WHERE code = N'IT201')
INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
SELECT NEWID(), id, N'IT201', N'Cấu trúc dữ liệu', N'Data Structures', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()
FROM departments WHERE code = N'CNTT';
GO

IF NOT EXISTS (SELECT 1 FROM courses WHERE code = N'IT202')
INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
SELECT NEWID(), id, N'IT202', N'Lập trình Java', N'Java Programming', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()
FROM departments WHERE code = N'CNTT';
GO

IF NOT EXISTS (SELECT 1 FROM courses WHERE code = N'IT203')
INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
SELECT NEWID(), id, N'IT203', N'Hệ điều hành', N'Operating Systems', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()
FROM departments WHERE code = N'CNTT';
GO

IF NOT EXISTS (SELECT 1 FROM courses WHERE code = N'BUS101')
INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
SELECT NEWID(), id, N'BUS101', N'Kinh tế vĩ mô', N'Macroeconomics', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()
FROM departments WHERE code = N'QTKD';
GO

IF NOT EXISTS (SELECT 1 FROM courses WHERE code = N'BUS102')
INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
SELECT NEWID(), id, N'BUS102', N'Marketing căn bản', N'Basic Marketing', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()
FROM departments WHERE code = N'QTKD';
GO

-- ===== Insert Registration Period =====
IF NOT EXISTS (SELECT 1 FROM registration_periods WHERE name = N'Đợt đăng ký Học kỳ 1 - 2024')
INSERT INTO registration_periods (id, name, semester_id, start_time, end_time, max_credits, min_credits, allow_retake, is_active, created_at)
SELECT NEWID(), N'Đợt đăng ký Học kỳ 1 - 2024', id, GETDATE(), DATEADD(day, 30, GETDATE()), 25, 10, 1, 1, GETDATE()
FROM semesters WHERE code = N'HK1_2024';
GO

-- End of seed script

