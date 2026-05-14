-- Seed data for demo registration flows (classpath copy)
-- MSSQL syntax, uses NEWID(), N'' for Vietnamese strings
-- Run on a dev database only

/* ===== 1) Create supporting tables if they do not exist ===== */
IF OBJECT_ID('dbo.departments', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.departments (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        code NVARCHAR(50) NOT NULL,
        name NVARCHAR(100) NOT NULL
    );
END

IF OBJECT_ID('dbo.academic_years', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.academic_years (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        code NVARCHAR(50) NOT NULL,
        name NVARCHAR(100) NOT NULL
    );
END

IF OBJECT_ID('dbo.school_years', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.school_years (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        academic_year_id UNIQUEIDENTIFIER NULL
    );
END

IF OBJECT_ID('dbo.semesters', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.semesters (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        code NVARCHAR(50) NOT NULL,
        name NVARCHAR(100) NOT NULL,
        school_year_id UNIQUEIDENTIFIER NULL
    );
END

IF OBJECT_ID('dbo.course_classes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.course_classes (
        id UNIQUEIDENTIFIER PRIMARY KEY,
        course_id UNIQUEIDENTIFIER NOT NULL,
        academic_year_id UNIQUEIDENTIFIER NULL,
        semester_id UNIQUEIDENTIFIER NULL,
        description NVARCHAR(255) NULL,
        max_students INT NULL,
        available_slots INT NULL
    );
END

IF OBJECT_ID('dbo.student_profiles', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.student_profiles (
        student_id UNIQUEIDENTIFIER PRIMARY KEY,
        cohort NVARCHAR(50) NULL,
        major NVARCHAR(100) NULL,
        faculty NVARCHAR(100) NULL
    );
END

/* ===== 2) Insert Departments ===== */
-- Insert two faculties
DECLARE @dept_it UNIQUEIDENTIFIER = NEWID();
DECLARE @dept_bus UNIQUEIDENTIFIER = NEWID();

INSERT INTO dbo.departments (id, code, name)
VALUES
    (@dept_it, N'CNTT', N'Công nghệ thông tin'),
    (@dept_bus, N'QTKD', N'Quản trị kinh doanh');

/* ===== 3) Insert Academic Years (K23, K24) ===== */
DECLARE @k23 UNIQUEIDENTIFIER = NEWID();
DECLARE @k24 UNIQUEIDENTIFIER = NEWID();

INSERT INTO dbo.academic_years (id, code, name)
VALUES
    (@k23, N'K23', N'Khóa 2023'),
    (@k24, N'K24', N'Khóa 2024');

/* ===== 4) Insert School Year 2024-2025 and Semesters ===== */
DECLARE @sy_2425 UNIQUEIDENTIFIER = NEWID();
INSERT INTO dbo.school_years (id, name, academic_year_id)
VALUES (@sy_2425, N'Năm học 2024-2025', @k24);

-- Semester Học kỳ 1
DECLARE @sem_hk1 UNIQUEIDENTIFIER = NEWID();
INSERT INTO dbo.semesters (id, code, name, school_year_id)
VALUES (@sem_hk1, N'HK1_2024', N'Học kỳ 1', @sy_2425);

/* ===== 5) Prepare Students ===== */
-- Existing table `students` exists in the schema. We'll insert three students.
DECLARE @stu_it_k24 UNIQUEIDENTIFIER = NEWID();
DECLARE @stu_it_k23 UNIQUEIDENTIFIER = NEWID();
DECLARE @stu_bus UNIQUEIDENTIFIER = NEWID();

INSERT INTO students (id, name, email)
VALUES
    (@stu_it_k24, N'Nguyễn Văn A', N'nguyenvana@demo.edu'),
    (@stu_it_k23, N'Trần Thị B', N'tranthib@demo.edu'),
    (@stu_bus, N'Phạm Văn C', N'phamvanc@demo.edu');

-- Profiles with cohort/major/faculty
INSERT INTO dbo.student_profiles (student_id, cohort, major, faculty)
VALUES
    (@stu_it_k24, N'K24', N'CNTT', N'Công nghệ thông tin'),
    (@stu_it_k23, N'K23', N'CNTT', N'Công nghệ thông tin'),
    (@stu_bus, N'K24', N'Quản trị kinh doanh', N'Quản trị kinh doanh');

/* ===== 6) Courses (some may already exist). We insert additional courses and link to departments ===== */
DECLARE @course_ds UNIQUEIDENTIFIER = NEWID(); -- Data Structures
DECLARE @course_java UNIQUEIDENTIFIER = NEWID();
DECLARE @course_os UNIQUEIDENTIFIER = NEWID();
DECLARE @course_macro UNIQUEIDENTIFIER = NEWID();
DECLARE @course_marketing UNIQUEIDENTIFIER = NEWID();

INSERT INTO courses (id, department_id, code, name, name_en, credits, theory_hours, practice_hours, self_study_hours, is_active, created_at)
VALUES
    (@course_ds, @dept_it, N'IT201', N'Cấu trúc dữ liệu', N'Data Structures', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
    (@course_java, @dept_it, N'IT202', N'Lập trình Java', N'Java Programming', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
    (@course_os, @dept_it, N'IT203', N'Hệ điều hành', N'Operating Systems', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
    (@course_macro, @dept_bus, N'BUS101', N'Kinh tế vĩ mô', N'Macroeconomics', 3.0, 30.0, 15.0, 45.0, 1, GETDATE()),
    (@course_marketing, @dept_bus, N'BUS102', N'Marketing căn bản', N'Basic Marketing', 3.0, 30.0, 15.0, 45.0, 1, GETDATE());

/* ===== 7) Course classes / sections ===== */
-- A: Lớp đúng tiến độ (belongs to academic_year_id = K24) => for K24 students
DECLARE @class_ds_k24 UNIQUEIDENTIFIER = NEWID();
DECLARE @class_java_k24 UNIQUEIDENTIFIER = NEWID();

INSERT INTO dbo.course_classes (id, course_id, academic_year_id, semester_id, description, max_students, available_slots)
VALUES
    (@class_ds_k24, @course_ds, @k24, @sem_hk1, N'Lớp chính khóa K24 - Cấu trúc dữ liệu', 50, 50),
    (@class_java_k24, @course_java, @k24, @sem_hk1, N'Lớp chính khóa K24 - Lập trình Java', 50, 50);

-- B: Lớp học lại / cải thiện (academic_year_id = NULL and description contains 'Lớp học lại')
DECLARE @class_java_retake UNIQUEIDENTIFIER = NEWID();
INSERT INTO dbo.course_classes (id, course_id, academic_year_id, semester_id, description, max_students, available_slots)
VALUES
    (@class_java_retake, @course_java, NULL, @sem_hk1, N'Lớp học lại - Lập trình Java', 30, 30);

/* ===== 8) Registration period (uses existing table registration_periods) ===== */
-- We insert a registration period pointing to semester HK1_2024
DECLARE @reg_period UNIQUEIDENTIFIER = NEWID();
INSERT INTO registration_periods (id, name, semester_id, start_time, end_time, max_credits, min_credits, allow_retake, is_active, created_at)
VALUES (@reg_period, N'Đợt đăng ký Học kỳ 1 - 2024', @sem_hk1, GETDATE(), DATEADD(day, 30, GETDATE()), 25, 10, 1, 1, GETDATE());

/* ===== 9) Course offerings (link course classes to registration period) ===== */
-- Insert offerings referencing course_classes.course_id (the existing course_offerings table expects course_id and registration_period_id)
DECLARE @off_ds UNIQUEIDENTIFIER = NEWID();
DECLARE @off_java UNIQUEIDENTIFIER = NEWID();
DECLARE @off_java_retake UNIQUEIDENTIFIER = NEWID();

INSERT INTO course_offerings (id, registration_period_id, course_id, course_name, credits, available_slots, max_slots)
VALUES
    (@off_ds, @reg_period, @course_ds, N'Cấu trúc dữ liệu', 3, 50, 50),
    (@off_java, @reg_period, @course_java, N'Lập trình Java', 3, 50, 50),
    (@off_java_retake, @reg_period, @course_java, N'Lập lại - Lập trình Java', 3, 30, 30);

/* ===== 10) Grades - different scenarios ===== */
-- Student IT K23 has a failing grade in Java -> eligible to retake
DECLARE @grade_it_k23_java UNIQUEIDENTIFIER = NEWID();
INSERT INTO grade (id, student_id, course_id, grade)
VALUES (@grade_it_k23_java, @stu_it_k23, @course_java, 3.5);

-- Student IT K24 has a high grade > 8.5 -> no need to retake
DECLARE @grade_it_k24_ds UNIQUEIDENTIFIER = NEWID();
INSERT INTO grade (id, student_id, course_id, grade)
VALUES (@grade_it_k24_ds, @stu_it_k24, @course_ds, 9.0);

-- Student BUS has not taken Marketing yet -> no grade

/* ===== 11) Course registrations - different states ===== */
-- Successful registration: student K24 registers for Java (offering)
DECLARE @reg_success UNIQUEIDENTIFIER = NEWID();
INSERT INTO course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, replaced_grade_id, registered_at, status, is_paid, created_at)
VALUES (@reg_success, @stu_it_k24, @class_java_k24, @reg_period, 1, NULL, GETDATE(), 1, 1, GETDATE());

-- Pending payment: student K24 registers for DS but not paid
DECLARE @reg_pending UNIQUEIDENTIFIER = NEWID();
INSERT INTO course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, replaced_grade_id, registered_at, status, is_paid, created_at)
VALUES (@reg_pending, @stu_it_k24, @class_ds_k24, @reg_period, 1, NULL, GETDATE(), 2, 0, GETDATE());

-- Cancelled: student BUS registers then cancels
DECLARE @reg_cancel UNIQUEIDENTIFIER = NEWID();
INSERT INTO course_registrations (id, student_id, course_class_id, registration_period_id, registration_type, replaced_grade_id, registered_at, status, is_paid, created_at)
VALUES (@reg_cancel, @stu_bus, @class_java_retake, @reg_period, 2, @grade_it_k23_java, GETDATE(), 3, 0, GETDATE());

/* ===== Notes =====
 - We created supporting tables to avoid changing existing core tables.
 - course_classes assists representing academic-year-linked sections and retake sections.
 - student_profiles stores cohort/major/faculty so we don't alter the existing students table.
 - Use this script on a development DB; do NOT run on production.
*/

