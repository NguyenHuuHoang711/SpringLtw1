package com.example.demo.modules.student.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.UUID;

@Data
@Entity
@Table(name = "student_profiles")
public class StudentProfile {
    @Id
    @Column(name = "student_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID studentId;

    @Column(name = "student_code", length = 50)
    private String studentCode;

    @Column(name = "student_name", columnDefinition = "NVARCHAR(100)")
    private String studentName;

    @Column(name = "email", columnDefinition = "NVARCHAR(100)")
    private String email;

    @Column(name = "cohort", length = 50)
    private String cohort;

    @Column(name = "major", columnDefinition = "NVARCHAR(100)")
    private String major;

    @Column(name = "faculty", columnDefinition = "NVARCHAR(100)")
    private String faculty;
}

