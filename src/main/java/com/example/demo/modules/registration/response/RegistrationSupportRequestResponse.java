package com.example.demo.modules.registration.response;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RegistrationSupportRequestResponse {
    private UUID id;
    private UUID studentId;
    private String studentCode;
    private String studentName;
    private String email;
    private String cohort;
    private String major;
    private String faculty;
    private String requestType;
    private UUID desiredCourseId;
    private String desiredCourseName;
    private String targetFaculty;
    private String targetCohort;
    private String targetSemester;
    private String reason;
    private String status;
    private String adminNote;
    private LocalDateTime createdAt;
    private LocalDateTime reviewedAt;
}

