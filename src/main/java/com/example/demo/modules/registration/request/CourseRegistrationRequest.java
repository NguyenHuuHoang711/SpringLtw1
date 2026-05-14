package com.example.demo.modules.registration.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class CourseRegistrationRequest {

    @NotNull(message = "Student ID is mandatory")
    private UUID studentId;

    @NotNull(message = "Course ID is mandatory")
    private UUID courseId; // Changed from courseClassId

    @NotNull(message = "Registration period ID is mandatory")
    private UUID registrationPeriodId;

    @NotNull(message = "Registration type is mandatory")
    private Integer registrationType;

    private UUID replacedGradeId;

    private boolean force = false; // For admin override
}