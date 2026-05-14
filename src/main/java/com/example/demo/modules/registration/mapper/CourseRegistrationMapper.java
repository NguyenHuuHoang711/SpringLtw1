package com.example.demo.modules.registration.mapper;

import com.example.demo.modules.registration.entity.CourseRegistration;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class CourseRegistrationMapper {

    public CourseRegistration toEntity(CourseRegistrationRequest request) {
        return CourseRegistration.builder()
                .studentId(request.getStudentId())
                .courseClassId(request.getCourseId()) // Maps courseId from request to courseClassId in entity
                .registrationPeriodId(request.getRegistrationPeriodId())
                .registrationType(request.getRegistrationType())
                .replacedGradeId(request.getReplacedGradeId())
                .registeredAt(LocalDateTime.now())
                .status(1) // 1=success
                .isPaid(false)
                .build();
    }

    public CourseRegistrationResponse toResponse(CourseRegistration entity) {
        CourseRegistrationResponse response = new CourseRegistrationResponse();
        response.setId(entity.getId());
        response.setStudentId(entity.getStudentId());
        response.setCourseId(entity.getCourseClassId()); // Maps courseClassId from entity back to courseId in response
        response.setRegistrationPeriodId(entity.getRegistrationPeriodId());
        response.setRegistrationType(entity.getRegistrationType());
        response.setReplacedGradeId(entity.getReplacedGradeId());
        response.setRegisteredAt(entity.getRegisteredAt());
        response.setStatus(entity.getStatus());
        response.setIsPaid(entity.getIsPaid());
        response.setCreatedAt(entity.getCreatedAt());
        response.setUpdatedAt(entity.getUpdatedAt());
        return response;
    }
}