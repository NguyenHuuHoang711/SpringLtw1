package com.example.demo.modules.course.controller;

import com.example.demo.modules.course.entity.CourseClass;
import com.example.demo.modules.course.repository.CourseClassRepository;
import com.example.demo.modules.registration.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/course-classes")
@RequiredArgsConstructor
@Tag(name = "Course Classes", description = "Course sections / classes used for registration")
public class CourseClassController {

    private final CourseClassRepository courseClassRepository;

    @GetMapping
    @Operation(summary = "Get course classes by academic year (optional)")
    public ResponseEntity<ApiResponse<List<CourseClass>>> getByAcademicYear(@RequestParam(value = "academic_year_id", required = false) UUID academicYearId) {
        List<CourseClass> list;
        if (academicYearId == null) list = courseClassRepository.findAll();
        else list = courseClassRepository.findByAcademicYearId(academicYearId);
        return ResponseEntity.ok(new ApiResponse<>(true, list, "Course classes retrieved"));
    }
}

