package com.example.demo.modules.registration.dto;
import java.util.UUID;

import org.hibernate.validator.constraints.Range;

import jakarta.validation.constraints.NotNull;
import lombok.Data;


@Data
public class CourseRegistrationRequest {
    @NotNull(message = "ID sinh viên không được để trống")
    private UUID studentId;

    @NotNull(message = "ID lớp học không được để trống")
    private UUID courseClassId;

    @NotNull(message = "ID đợt đăng ký không được để trống")
    private UUID registrationPeriodId;

    @Range(min = 1, max = 3, message = "Loại đăng ký không hợp lệ (1: Mới, 2: Lại, 3: Cải thiện)")
    private Byte registrationType;

    private UUID replacedGradeId;
}
