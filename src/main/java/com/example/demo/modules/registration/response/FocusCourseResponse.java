package com.example.demo.modules.registration.response;

import lombok.Data;

import java.util.UUID;

@Data
public class FocusCourseResponse {
    private UUID courseId;
    private String courseCode;
    private String courseName;
    private Double bestGrade;
    private Double credits;
    private String status; // FAILED | IMPROVEMENT
}

