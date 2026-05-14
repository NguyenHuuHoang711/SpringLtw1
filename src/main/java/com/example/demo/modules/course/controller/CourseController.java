package com.example.demo.modules.course.controller;

import com.example.demo.modules.course.entity.Course;
import com.example.demo.modules.course.repository.CourseRepository;
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
@RequestMapping("/api/courses")
@RequiredArgsConstructor
@Tag(name = "Courses", description = "APIs for retrieving course information")
public class CourseController {

    private final CourseRepository courseRepository;

    @GetMapping
    @Operation(summary = "Get Multiple Courses by IDs", description = "Retrieves a list of course details for the given UUIDs.")
    public ResponseEntity<ApiResponse<List<Course>>> getCoursesByIds(@RequestParam("ids") List<UUID> ids) {
        List<Course> courses = courseRepository.findAllById(ids);
        return ResponseEntity.ok(new ApiResponse<>(true, courses, "Courses retrieved successfully"));
    }
}
