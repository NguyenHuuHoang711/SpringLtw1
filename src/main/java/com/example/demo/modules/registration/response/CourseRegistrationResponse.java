package com.example.demo.modules.registration.response;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class CourseRegistrationResponse {
    private UUID id;
    private UUID studentId;
    private UUID courseId; // Changed from courseClassId
    private UUID registrationPeriodId;
    private Integer registrationType;
    private UUID replacedGradeId;
    private LocalDateTime registeredAt;
    private Integer status;
    private Boolean isPaid;
    // Removed rowVersion from response. Optimistic locking is usually handled differently.
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}