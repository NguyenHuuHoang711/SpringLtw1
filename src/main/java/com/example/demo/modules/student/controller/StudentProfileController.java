package com.example.demo.modules.student.controller;

import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.student.entity.StudentProfile;
import com.example.demo.modules.student.repository.StudentProfileRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Arrays;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/student-profiles")
@RequiredArgsConstructor
@Tag(name = "Student Profiles", description = "Demo student login data and faculty/cohort lookup")
public class StudentProfileController {

    private final StudentProfileRepository studentProfileRepository;

    @GetMapping
    @Operation(summary = "List all student profiles for demo login")
    public ResponseEntity<ApiResponse<List<StudentProfile>>> getAll() {
        return ResponseEntity.ok(new ApiResponse<>(true, studentProfileRepository.findAll(), "Student profiles retrieved"));
    }

    @GetMapping("/{studentId}")
    @Operation(summary = "Get student profile by student ID")
    public ResponseEntity<ApiResponse<StudentProfile>> getByStudentId(@PathVariable UUID studentId) {
        return studentProfileRepository.findByStudentId(studentId)
                .<ResponseEntity<ApiResponse<StudentProfile>>>map(profile -> ResponseEntity.ok(new ApiResponse<>(true, profile, "Student profile retrieved")))
                .orElseGet(() -> ResponseEntity.status(404).body(new ApiResponse<>(false, new StudentProfile(), "Student profile not found")));
    }

    @GetMapping("/batch")
    @Operation(summary = "Get student profiles by a list of student IDs")
    public ResponseEntity<ApiResponse<List<StudentProfile>>> getBatch(@RequestParam("ids") String ids) {
        List<UUID> studentIds = Arrays.stream(ids.split("[\\s,]+"))
                .filter(s -> !s.isBlank())
                .map(UUID::fromString)
                .collect(Collectors.toList());

        List<StudentProfile> profiles = studentProfileRepository.findAllById(studentIds);
        return ResponseEntity.ok(new ApiResponse<>(true, profiles, "Student profiles retrieved"));
    }
}

