
package com.example.demo.modules.registration.request;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RegistrationPeriodRequest {

    @NotBlank(message = "Name is mandatory")
    private String name;

    @NotNull(message = "Semester ID is mandatory")
    private UUID semesterId;

    @NotNull(message = "Start time is mandatory")
    @FutureOrPresent(message = "Start time must be in the present or future")
    private LocalDateTime startTime;

    @NotNull(message = "End time is mandatory")
    @Future(message = "End time must be in the future")
    private LocalDateTime endTime;

    private String targetConfig;

    @NotNull(message = "Max credits is mandatory")
    @Min(value = 1, message = "Max credits must be at least 1")
    private Integer maxCredits;

    @NotNull(message = "Min credits is mandatory")
    @Min(value = 0, message = "Min credits must be at least 0")
    private Integer minCredits;

    @NotNull(message = "Allow retake is mandatory")
    private Boolean allowRetake;

    @NotNull(message = "Is open is mandatory")
    private Boolean isOpen;

    @NotNull(message = "Is active is mandatory")
    private Boolean isActive;
}
