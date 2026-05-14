
package com.example.demo.modules.registration.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class EquivalentCourseRequest {

    @NotNull(message = "Original course ID is mandatory")
    private UUID originalCourseId;

    @NotNull(message = "Equivalent course ID is mandatory")
    private UUID equivalentCourseId;

    @NotNull(message = "Equivalence type is mandatory")
    private Integer equivalenceType;

    @NotNull(message = "Effect date is mandatory")
    private LocalDate effectDate;

    @NotNull(message = "Is active is mandatory")
    private Boolean isActive;

    private String note;
}
