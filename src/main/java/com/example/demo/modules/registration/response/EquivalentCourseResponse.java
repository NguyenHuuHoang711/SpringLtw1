
package com.example.demo.modules.registration.response;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class EquivalentCourseResponse {
    private UUID id;
    private UUID originalCourseId;
    private UUID equivalentCourseId;
    private Integer equivalenceType;
    private LocalDate effectDate;
    private Boolean isActive;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
