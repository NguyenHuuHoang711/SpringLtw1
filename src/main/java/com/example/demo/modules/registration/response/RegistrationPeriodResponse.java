
package com.example.demo.modules.registration.response;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RegistrationPeriodResponse {
    private UUID id;
    private String name;
    private UUID semesterId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String targetConfig;
    private Integer maxCredits;
    private Integer minCredits;
    private Boolean allowRetake;
    private Boolean isOpen;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
