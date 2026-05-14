package com.example.demo.modules.registration.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "registration_requests")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationSupportRequest {
    @Id
    @GeneratedValue
    @Column(name = "id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "student_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
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

    @Column(name = "request_type", length = 30, nullable = false)
    private String requestType;

    @Column(name = "desired_course_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID desiredCourseId;

    @Column(name = "desired_course_name", columnDefinition = "NVARCHAR(255)")
    private String desiredCourseName;

    @Column(name = "target_faculty", columnDefinition = "NVARCHAR(100)")
    private String targetFaculty;

    @Column(name = "target_cohort", length = 50)
    private String targetCohort;

    @Column(name = "target_semester", columnDefinition = "NVARCHAR(100)")
    private String targetSemester;

    @Column(name = "reason", columnDefinition = "NVARCHAR(MAX)", nullable = false)
    private String reason;

    @Column(name = "status", length = 20, nullable = false)
    @Builder.Default
    private String status = "PENDING";

    @Column(name = "admin_note", columnDefinition = "NVARCHAR(MAX)")
    private String adminNote;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "reviewed_at")
    private LocalDateTime reviewedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        if (this.reviewedAt == null && ("APPROVED".equals(this.status) || "REJECTED".equals(this.status))) {
            this.reviewedAt = LocalDateTime.now();
        }
    }
}

