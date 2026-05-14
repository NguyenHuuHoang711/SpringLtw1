package com.example.demo.modules.registration.mapper;

import com.example.demo.modules.registration.entity.RegistrationPeriod;
import com.example.demo.modules.registration.request.RegistrationPeriodRequest;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;
import org.springframework.stereotype.Component;

@Component
public class RegistrationPeriodMapper {

    public RegistrationPeriod toEntity(RegistrationPeriodRequest request) {
        return RegistrationPeriod.builder()
                .name(request.getName())
                .semesterId(request.getSemesterId())
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .targetConfig(request.getTargetConfig())
                .maxCredits(request.getMaxCredits())
                .minCredits(request.getMinCredits())
                .allowRetake(request.getAllowRetake())
                // .isOpen(request.getIsOpen()) // Removed: isOpen doesn't exist in entity
                .isActive(request.getIsActive())
                .build();
    }

    public void updateEntity(RegistrationPeriod entity, RegistrationPeriodRequest request) {
        entity.setName(request.getName());
        entity.setSemesterId(request.getSemesterId());
        entity.setStartTime(request.getStartTime());
        entity.setEndTime(request.getEndTime());
        entity.setTargetConfig(request.getTargetConfig());
        entity.setMaxCredits(request.getMaxCredits());
        entity.setMinCredits(request.getMinCredits());
        entity.setAllowRetake(request.getAllowRetake());
        // entity.setIsOpen(request.getIsOpen()); // Removed
        entity.setIsActive(request.getIsActive());
    }

    public RegistrationPeriodResponse toResponse(RegistrationPeriod entity) {
        RegistrationPeriodResponse response = new RegistrationPeriodResponse();
        response.setId(entity.getId());
        response.setName(entity.getName());
        response.setSemesterId(entity.getSemesterId());
        response.setStartTime(entity.getStartTime());
        response.setEndTime(entity.getEndTime());
        response.setTargetConfig(entity.getTargetConfig());
        response.setMaxCredits(entity.getMaxCredits());
        response.setMinCredits(entity.getMinCredits());
        response.setAllowRetake(entity.getAllowRetake());
        // response.setIsOpen(entity.getIsOpen()); // Removed
        response.setIsActive(entity.getIsActive());
        response.setCreatedAt(entity.getCreatedAt());
        response.setUpdatedAt(entity.getUpdatedAt());
        return response;
    }
}