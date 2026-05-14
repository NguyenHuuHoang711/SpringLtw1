package com.example.demo.modules.registration.controller.student;

import com.example.demo.modules.registration.entity.CourseOffering;
import com.example.demo.modules.course.entity.EquivalentCourse;
import com.example.demo.modules.grade.entity.Grade;
import com.example.demo.modules.registration.repository.CourseOfferingRepository;
import com.example.demo.modules.course.repository.EquivalentCourseRepository;
import com.example.demo.modules.grade.repository.GradeRepository;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.FocusCourseResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;
import com.example.demo.modules.registration.service.RegistrationService;
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
@RequestMapping("/api/registration")
@RequiredArgsConstructor
@Tag(name = "Student Registration", description = "APIs for students to view periods, register for courses, and manage their registrations")
public class RegistrationController {

    private final RegistrationService registrationService;
    private final CourseOfferingRepository courseOfferingRepository;
    private final GradeRepository gradeRepository;
    private final EquivalentCourseRepository equivalentCourseRepository;

    @GetMapping("/periods/active")
    @Operation(summary = "Get Active Registration Periods", description = "Retrieves active periods, optionally filtered by the student's faculty/cohort/major when student_id is provided.")
    public ResponseEntity<ApiResponse<List<RegistrationPeriodResponse>>> getActiveRegistrationPeriods(
            @RequestParam(value = "student_id", required = false) UUID studentId) {
        List<RegistrationPeriodResponse> periods = (studentId != null)
                ? registrationService.getEligibleRegistrationPeriods(studentId)
                : registrationService.getActiveRegistrationPeriods();
        ApiResponse<List<RegistrationPeriodResponse>> response = new ApiResponse<>(true, periods, "Active registration periods retrieved successfully");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/periods/eligible")
    @Operation(summary = "Get Eligible Registration Periods", description = "Retrieves periods filtered by the student's faculty/cohort/major and current time window.")
    public ResponseEntity<ApiResponse<List<RegistrationPeriodResponse>>> getEligibleRegistrationPeriods(@RequestParam("student_id") UUID studentId) {
        List<RegistrationPeriodResponse> periods = registrationService.getEligibleRegistrationPeriods(studentId);
        return ResponseEntity.ok(new ApiResponse<>(true, periods, "Eligible registration periods retrieved successfully"));
    }

    @GetMapping("/offerings")
    @Operation(summary = "Get Available Course Offerings", description = "Retrieves all offered courses for a given registration period.")
    public ResponseEntity<ApiResponse<List<CourseOffering>>> getOfferings(@RequestParam("period_id") UUID periodId) {
        List<CourseOffering> offerings = courseOfferingRepository.findByRegistrationPeriodId(periodId);
        return ResponseEntity.ok(new ApiResponse<>(true, offerings, "Offerings retrieved successfully"));
    }

    @GetMapping("/grades/me")
    @Operation(summary = "Get My Grades", description = "Retrieves all grades for the currently authenticated student.")
    public ResponseEntity<ApiResponse<List<Grade>>> getMyGrades(@RequestParam("student_id") UUID studentId) {
        // Normally retrieved from security context. We use a param for simulation.
        List<Grade> grades = gradeRepository.findByStudentId(studentId);
        return ResponseEntity.ok(new ApiResponse<>(true, grades, "Grades retrieved successfully"));
    }

    @GetMapping("/focus-courses")
    @Operation(summary = "Get Focus Courses", description = "Returns courses that need retake or improvement based on the student's best grade per course.")
    public ResponseEntity<ApiResponse<List<FocusCourseResponse>>> getFocusCourses(@RequestParam("student_id") UUID studentId) {
        List<FocusCourseResponse> focusCourses = registrationService.getFocusCourses(studentId);
        return ResponseEntity.ok(new ApiResponse<>(true, focusCourses, "Focus courses retrieved successfully"));
    }

    @GetMapping("/equivalent-courses")
    @Operation(summary = "Get Equivalent Courses", description = "Retrieves all equivalent courses logic rules.")
    public ResponseEntity<ApiResponse<List<EquivalentCourse>>> getEquivalentCourses() {
        List<EquivalentCourse> equivalents = equivalentCourseRepository.findAll();
        return ResponseEntity.ok(new ApiResponse<>(true, equivalents, "Equivalents retrieved successfully"));
    }

    @GetMapping("/me")
    @Operation(summary = "Get My Registrations", description = "Retrieves all course registrations for the currently authenticated student.")
    public ResponseEntity<ApiResponse<List<CourseRegistrationResponse>>> getMyRegistrations(@RequestParam("student_id") UUID studentId) {
        // Normally retrieved from security context. We use a param for simulation.
        List<CourseRegistrationResponse> registrations = registrationService.getMyRegistrations(studentId);
        ApiResponse<List<CourseRegistrationResponse>> response = new ApiResponse<>(true, registrations, "Your registrations retrieved successfully");
        return ResponseEntity.ok(response);
    }

    @PostMapping
    @Operation(summary = "Register for a Course", description = "Registers the authenticated student for a specific course within an active registration period.")
    public ResponseEntity<ApiResponse<CourseRegistrationResponse>> registerCourse(@Valid @RequestBody CourseRegistrationRequest request) {
        CourseRegistrationResponse registration = registrationService.registerCourse(request);
        ApiResponse<CourseRegistrationResponse> response = new ApiResponse<>(true, registration, "Course registered successfully");
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PatchMapping("/{id}/cancel")
    @Operation(summary = "Cancel Course Registration", description = "Cancels a specific course registration for the authenticated student, provided it has not been paid for.")
    public ResponseEntity<ApiResponse<CourseRegistrationResponse>> cancelRegistration(
            @PathVariable UUID id, 
            @RequestParam("student_id") UUID studentId) {
        // Normally retrieved from security context. We use a param for simulation.
        CourseRegistrationResponse registration = registrationService.cancelRegistration(id, studentId);
        ApiResponse<CourseRegistrationResponse> response = new ApiResponse<>(true, registration, "Registration cancelled successfully");
        return ResponseEntity.ok(response);
    }
}
