package com.example.demo.modules.academic.controller;

import com.example.demo.modules.academic.entity.AcademicYear;
import com.example.demo.modules.academic.repository.AcademicYearRepository;
import com.example.demo.modules.registration.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/academic-years")
@RequiredArgsConstructor
@Tag(name = "Academic Years", description = "Academic cohorts like K23, K24")
public class AcademicYearController {

    private final AcademicYearRepository academicYearRepository;

    @GetMapping
    @Operation(summary = "Get academic years")
    public ResponseEntity<ApiResponse<List<AcademicYear>>> getAll() {
        List<AcademicYear> list = academicYearRepository.findAll();
        return ResponseEntity.ok(new ApiResponse<>(true, list, "Academic years retrieved"));
    }
}

