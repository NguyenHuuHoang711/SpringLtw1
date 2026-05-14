package com.example.demo.modules.semester.controller;

import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.semester.entity.Semester;
import com.example.demo.modules.semester.repository.SemesterRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/semesters")
@RequiredArgsConstructor
@Tag(name = "Semesters", description = "Academic semesters")
public class SemesterController {

    private final SemesterRepository semesterRepository;

    @GetMapping
    @Operation(summary = "Get semesters")
    public ResponseEntity<ApiResponse<List<Semester>>> getAll() {
        List<Semester> list = semesterRepository.findAll();
        return ResponseEntity.ok(new ApiResponse<>(true, list, "Semesters retrieved"));
    }
}

