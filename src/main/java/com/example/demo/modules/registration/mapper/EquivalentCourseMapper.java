
package com.example.demo.modules.registration.mapper;

import com.example.demo.modules.course.entity.EquivalentCourse;
import com.example.demo.modules.registration.request.EquivalentCourseRequest;
import com.example.demo.modules.registration.response.EquivalentCourseResponse;
import org.springframework.stereotype.Component;

@Component
public class EquivalentCourseMapper {

    public EquivalentCourse toEntity(EquivalentCourseRequest request) {
        EquivalentCourse entity = new EquivalentCourse();
        entity.setOriginalCourseId(request.getOriginalCourseId());
        entity.setEquivalentCourseId(request.getEquivalentCourseId());
        entity.setEquivalenceType(request.getEquivalenceType());
        entity.setEffectDate(request.getEffectDate());
        entity.setIsActive(request.getIsActive());
        entity.setNote(request.getNote());
        return entity;
    }

    public void updateEntity(EquivalentCourse entity, EquivalentCourseRequest request) {
        entity.setOriginalCourseId(request.getOriginalCourseId());
        entity.setEquivalentCourseId(request.getEquivalentCourseId());
        entity.setEquivalenceType(request.getEquivalenceType());
        entity.setEffectDate(request.getEffectDate());
        entity.setIsActive(request.getIsActive());
        entity.setNote(request.getNote());
    }

    public EquivalentCourseResponse toResponse(EquivalentCourse entity) {
        EquivalentCourseResponse response = new EquivalentCourseResponse();
        response.setId(entity.getId());
        response.setOriginalCourseId(entity.getOriginalCourseId());
        response.setEquivalentCourseId(entity.getEquivalentCourseId());
        response.setEquivalenceType(entity.getEquivalenceType());
        response.setEffectDate(entity.getEffectDate());
        response.setIsActive(entity.getIsActive());
        response.setNote(entity.getNote());
        response.setCreatedAt(entity.getCreatedAt());
        response.setUpdatedAt(entity.getUpdatedAt());
        return response;
    }
}
