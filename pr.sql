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