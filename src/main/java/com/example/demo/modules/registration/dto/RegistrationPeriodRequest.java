package com.example.demo.modules.registration.dto;
import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
@Data
public class RegistrationPeriodRequest {
    @NotBlank(message = "Tên đợt không được để trống")
    private String name;

    @NotNull(message = "Semester ID là bắt buộc")
    private UUID semesterId;

    @NotNull(message = "Thời gian bắt đầu là bắt buộc")
    private LocalDateTime startTime;

    @NotNull(message = "Thời gian kết thúc là bắt buộc")
    private LocalDateTime endTime;

    private String targetConfig; 

    private Integer maxCredits = 25;
    private Integer minCredits = 12;
    private Boolean allowRetake = true;
}