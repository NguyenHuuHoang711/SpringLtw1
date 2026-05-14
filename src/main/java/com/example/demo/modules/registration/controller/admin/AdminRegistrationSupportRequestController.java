package com.example.demo.modules.registration.controller.admin;

import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.registration.response.RegistrationSupportRequestResponse;
import com.example.demo.modules.registration.service.RegistrationSupportRequestService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/registration/requests")
@RequiredArgsConstructor
@Tag(name = "Admin Registration Requests", description = "Admin review APIs for student support requests")
public class AdminRegistrationSupportRequestController {

    private final RegistrationSupportRequestService requestService;

    @GetMapping
    @Operation(summary = "Get all support requests")
    public ResponseEntity<ApiResponse<List<RegistrationSupportRequestResponse>>> getAll() {
        return ResponseEntity.ok(new ApiResponse<>(true, requestService.getAllRequests(), "Requests retrieved"));
    }

    @PatchMapping("/{id}/approve")
    @Operation(summary = "Approve request")
    public ResponseEntity<ApiResponse<RegistrationSupportRequestResponse>> approve(@PathVariable UUID id,
                                                                                   @RequestParam(value = "note", required = false) String note) {
        return ResponseEntity.ok(new ApiResponse<>(true, requestService.approve(id, note), "Request approved"));
    }

    @PatchMapping("/{id}/reject")
    @Operation(summary = "Reject request")
    public ResponseEntity<ApiResponse<RegistrationSupportRequestResponse>> reject(@PathVariable UUID id,
                                                                                  @RequestParam(value = "note", required = false) String note) {
        return ResponseEntity.ok(new ApiResponse<>(true, requestService.reject(id, note), "Request rejected"));
    }
}

