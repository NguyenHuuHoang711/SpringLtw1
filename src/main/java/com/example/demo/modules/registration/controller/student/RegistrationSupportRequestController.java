package com.example.demo.modules.registration.controller.student;

import com.example.demo.modules.registration.request.RegistrationSupportRequestCreateRequest;
import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.registration.response.RegistrationSupportRequestResponse;
import com.example.demo.modules.registration.service.RegistrationSupportRequestService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/registration/requests")
@RequiredArgsConstructor
@Tag(name = "Student Registration Requests", description = "Student request APIs")
public class RegistrationSupportRequestController {

    private final RegistrationSupportRequestService requestService;

    @PostMapping
    @Operation(summary = "Create support request")
    public ResponseEntity<ApiResponse<RegistrationSupportRequestResponse>> create(@Valid @RequestBody RegistrationSupportRequestCreateRequest request) {
        RegistrationSupportRequestResponse created = requestService.create(request);
        return new ResponseEntity<>(new ApiResponse<>(true, created, "Request submitted"), HttpStatus.CREATED);
    }

    @GetMapping("/me")
    @Operation(summary = "Get my requests")
    public ResponseEntity<ApiResponse<List<RegistrationSupportRequestResponse>>> getMyRequests(@RequestParam("student_id") UUID studentId) {
        return ResponseEntity.ok(new ApiResponse<>(true, requestService.getMyRequests(studentId), "My requests retrieved"));
    }
}

