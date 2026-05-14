package com.example.demo.modules.registration.request;

import lombok.Data;

import java.util.UUID;

@Data
public class CourseOfferingBulkRequest {
    private UUID registrationPeriodId;
    private String courseIds; // Can be space or newline separated
    private Integer maxSlots; // Applied to all added courses
}
