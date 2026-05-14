package com.example.demo.modules.registration.service;

import com.example.demo.exception.NotFoundException;
import com.example.demo.modules.registration.entity.RegistrationSupportRequest;
import com.example.demo.modules.registration.repository.RegistrationSupportRequestRepository;
import com.example.demo.modules.registration.request.RegistrationSupportRequestCreateRequest;
import com.example.demo.modules.registration.response.RegistrationSupportRequestResponse;
import com.example.demo.modules.student.entity.StudentProfile;
import com.example.demo.modules.student.repository.StudentProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RegistrationSupportRequestServiceImpl implements RegistrationSupportRequestService {

    private final RegistrationSupportRequestRepository requestRepository;
    private final StudentProfileRepository studentProfileRepository;

    @Override
    @Transactional
    public RegistrationSupportRequestResponse create(RegistrationSupportRequestCreateRequest request) {
        StudentProfile profile = studentProfileRepository.findByStudentId(request.getStudentId())
                .orElseThrow(() -> new NotFoundException("Student profile not found"));

        RegistrationSupportRequest entity = RegistrationSupportRequest.builder()
                .studentId(profile.getStudentId())
                .studentCode(profile.getStudentCode())
                .studentName(profile.getStudentName())
                .email(profile.getEmail())
                .cohort(profile.getCohort())
                .major(profile.getMajor())
                .faculty(profile.getFaculty())
                .requestType(request.getRequestType().toUpperCase())
                .desiredCourseId(request.getDesiredCourseId())
                .desiredCourseName(request.getDesiredCourseName())
                .targetFaculty(request.getTargetFaculty())
                .targetCohort(request.getTargetCohort())
                .targetSemester(request.getTargetSemester())
                .reason(request.getReason())
                .status("PENDING")
                .build();

        return toResponse(requestRepository.save(entity));
    }

    @Override
    public List<RegistrationSupportRequestResponse> getMyRequests(UUID studentId) {
        return requestRepository.findByStudentIdOrderByCreatedAtDesc(studentId)
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Override
    public List<RegistrationSupportRequestResponse> getAllRequests() {
        return requestRepository.findAllByOrderByCreatedAtDesc()
                .stream().map(this::toResponse).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public RegistrationSupportRequestResponse approve(UUID id, String adminNote) {
        RegistrationSupportRequest entity = requestRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Request not found"));
        entity.setStatus("APPROVED");
        entity.setAdminNote(adminNote);
        return toResponse(requestRepository.save(entity));
    }

    @Override
    @Transactional
    public RegistrationSupportRequestResponse reject(UUID id, String adminNote) {
        RegistrationSupportRequest entity = requestRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Request not found"));
        entity.setStatus("REJECTED");
        entity.setAdminNote(adminNote);
        return toResponse(requestRepository.save(entity));
    }

    private RegistrationSupportRequestResponse toResponse(RegistrationSupportRequest entity) {
        RegistrationSupportRequestResponse response = new RegistrationSupportRequestResponse();
        response.setId(entity.getId());
        response.setStudentId(entity.getStudentId());
        response.setStudentCode(entity.getStudentCode());
        response.setStudentName(entity.getStudentName());
        response.setEmail(entity.getEmail());
        response.setCohort(entity.getCohort());
        response.setMajor(entity.getMajor());
        response.setFaculty(entity.getFaculty());
        response.setRequestType(entity.getRequestType());
        response.setDesiredCourseId(entity.getDesiredCourseId());
        response.setDesiredCourseName(entity.getDesiredCourseName());
        response.setTargetFaculty(entity.getTargetFaculty());
        response.setTargetCohort(entity.getTargetCohort());
        response.setTargetSemester(entity.getTargetSemester());
        response.setReason(entity.getReason());
        response.setStatus(entity.getStatus());
        response.setAdminNote(entity.getAdminNote());
        response.setCreatedAt(entity.getCreatedAt());
        response.setReviewedAt(entity.getReviewedAt());
        return response;
    }
}

