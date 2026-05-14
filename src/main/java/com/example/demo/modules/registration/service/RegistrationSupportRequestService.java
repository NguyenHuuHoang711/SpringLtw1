package com.example.demo.modules.registration.service;

import com.example.demo.modules.registration.request.RegistrationSupportRequestCreateRequest;
import com.example.demo.modules.registration.response.RegistrationSupportRequestResponse;

import java.util.List;
import java.util.UUID;

public interface RegistrationSupportRequestService {
    RegistrationSupportRequestResponse create(RegistrationSupportRequestCreateRequest request);
    List<RegistrationSupportRequestResponse> getMyRequests(UUID studentId);
    List<RegistrationSupportRequestResponse> getAllRequests();
    RegistrationSupportRequestResponse approve(UUID id, String adminNote);
    RegistrationSupportRequestResponse reject(UUID id, String adminNote);
}

