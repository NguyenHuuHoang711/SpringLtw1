package com.example.demo.modules.registration.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class RegistrationSupportRequestCreateRequest {
    @NotNull
    private UUID studentId;

    @NotBlank
    private String requestType; // OPEN_CLASS | OPEN_PERIOD

    private UUID desiredCourseId;
    private String desiredCourseName;
    private String targetFaculty;
    private String targetCohort;
    private String targetSemester;

    @NotBlank
    private String reason;
}

