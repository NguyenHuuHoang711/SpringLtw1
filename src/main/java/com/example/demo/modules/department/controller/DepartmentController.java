package com.example.demo.modules.department.controller;

import com.example.demo.modules.department.entity.Department;
import com.example.demo.modules.department.repository.DepartmentRepository;
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
@RequestMapping("/api/departments")
@RequiredArgsConstructor
@Tag(name = "Departments", description = "List of faculties / departments")
public class DepartmentController {

    private final DepartmentRepository departmentRepository;

    @GetMapping
    @Operation(summary = "Get all departments")
    public ResponseEntity<ApiResponse<List<Department>>> getAll() {
        List<Department> list = departmentRepository.findAll();
        return ResponseEntity.ok(new ApiResponse<>(true, list, "Departments retrieved"));
    }
}

