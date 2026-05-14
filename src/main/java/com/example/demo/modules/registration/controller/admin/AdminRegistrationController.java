package com.example.demo.modules.registration.controller.admin;

import com.example.demo.modules.registration.entity.CourseOffering;
import com.example.demo.modules.registration.repository.CourseOfferingRepository;
import com.example.demo.modules.registration.request.CourseOfferingBulkRequest;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.request.EquivalentCourseRequest;
import com.example.demo.modules.registration.request.RegistrationPeriodRequest;
import com.example.demo.modules.registration.response.ApiResponse;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.EquivalentCourseResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;
import com.example.demo.modules.registration.service.AdminRegistrationService;
import com.example.demo.modules.registration.service.RegistrationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/registration")
@RequiredArgsConstructor
@Tag(name = "Admin Registration", description = "APIs for administrators to manage registration periods, equivalent courses, and registrations")
public class AdminRegistrationController {

    private final AdminRegistrationService adminService;
    private final RegistrationService registrationService;
    private final CourseOfferingRepository courseOfferingRepository;

    // CRUD for Registration Periods
    @PostMapping("/periods")
    @Operation(summary = "Create Registration Period", description = "Creates a new course registration period.")
    public ResponseEntity<ApiResponse<RegistrationPeriodResponse>> createRegistrationPeriod(@Valid @RequestBody RegistrationPeriodRequest request) {
        RegistrationPeriodResponse period = adminService.createRegistrationPeriod(request);
        return new ResponseEntity<>(new ApiResponse<>(true, period, "Registration period created"), HttpStatus.CREATED);
    }

    @GetMapping("/periods")
    @Operation(summary = "Get All Registration Periods", description = "Retrieves all registration periods.")
    public ResponseEntity<ApiResponse<List<RegistrationPeriodResponse>>> getAllRegistrationPeriods() {
        List<RegistrationPeriodResponse> periods = adminService.getAllRegistrationPeriods();
        return ResponseEntity.ok(new ApiResponse<>(true, periods, "All registration periods retrieved"));
    }

    @GetMapping("/periods/{id}")
    @Operation(summary = "Get Registration Period by ID", description = "Retrieves a specific registration period by its ID.")
    public ResponseEntity<ApiResponse<RegistrationPeriodResponse>> getRegistrationPeriodById(@PathVariable UUID id) {
        RegistrationPeriodResponse period = adminService.getRegistrationPeriodById(id);
        return ResponseEntity.ok(new ApiResponse<>(true, period, "Registration period retrieved"));
    }

    @PutMapping("/periods/{id}")
    @Operation(summary = "Update Registration Period", description = "Updates an existing registration period.")
    public ResponseEntity<ApiResponse<RegistrationPeriodResponse>> updateRegistrationPeriod(@PathVariable UUID id, @Valid @RequestBody RegistrationPeriodRequest request) {
        RegistrationPeriodResponse period = adminService.updateRegistrationPeriod(id, request);
        return ResponseEntity.ok(new ApiResponse<>(true, period, "Registration period updated"));
    }

    @DeleteMapping("/periods/{id}")
    @Operation(summary = "Delete Registration Period", description = "Deletes a registration period by ID.")
    public ResponseEntity<ApiResponse<Void>> deleteRegistrationPeriod(@PathVariable UUID id) {
        adminService.deleteRegistrationPeriod(id);
        return ResponseEntity.ok(new ApiResponse<>(true, null, "Registration period deleted"));
    }

    // CRUD for Equivalent Courses
    @PostMapping("/equivalent-courses")
    @Operation(summary = "Create Equivalent Course", description = "Defines a new equivalent course relationship.")
    public ResponseEntity<ApiResponse<EquivalentCourseResponse>> createEquivalentCourse(@Valid @RequestBody EquivalentCourseRequest request) {
        EquivalentCourseResponse course = adminService.createEquivalentCourse(request);
        return new ResponseEntity<>(new ApiResponse<>(true, course, "Equivalent course created"), HttpStatus.CREATED);
    }

    @GetMapping("/equivalent-courses")
    @Operation(summary = "Get All Equivalent Courses", description = "Retrieves all equivalent course relationships.")
    public ResponseEntity<ApiResponse<List<EquivalentCourseResponse>>> getAllEquivalentCourses() {
        List<EquivalentCourseResponse> courses = adminService.getAllEquivalentCourses();
        return ResponseEntity.ok(new ApiResponse<>(true, courses, "All equivalent courses retrieved"));
    }

    @GetMapping("/equivalent-courses/{id}")
    @Operation(summary = "Get Equivalent Course by ID", description = "Retrieves a specific equivalent course relationship by its ID.")
    public ResponseEntity<ApiResponse<EquivalentCourseResponse>> getEquivalentCourseById(@PathVariable UUID id) {
        EquivalentCourseResponse course = adminService.getEquivalentCourseById(id);
        return ResponseEntity.ok(new ApiResponse<>(true, course, "Equivalent course retrieved"));
    }

    @PutMapping("/equivalent-courses/{id}")
    @Operation(summary = "Update Equivalent Course", description = "Updates an existing equivalent course relationship.")
    public ResponseEntity<ApiResponse<EquivalentCourseResponse>> updateEquivalentCourse(@PathVariable UUID id, @Valid @RequestBody EquivalentCourseRequest request) {
        EquivalentCourseResponse course = adminService.updateEquivalentCourse(id, request);
        return ResponseEntity.ok(new ApiResponse<>(true, course, "Equivalent course updated"));
    }

    @DeleteMapping("/equivalent-courses/{id}")
    @Operation(summary = "Delete Equivalent Course", description = "Deletes an equivalent course relationship by ID.")
    public ResponseEntity<ApiResponse<Void>> deleteEquivalentCourse(@PathVariable UUID id) {
        adminService.deleteEquivalentCourse(id);
        return ResponseEntity.ok(new ApiResponse<>(true, null, "Equivalent course deleted"));
    }

    // Course Registration Management
    @GetMapping("/course-registrations")
    @Operation(summary = "Get All Course Registrations", description = "Retrieves all course registrations made by students.")
    public ResponseEntity<ApiResponse<List<CourseRegistrationResponse>>> getAllCourseRegistrations() {
        List<CourseRegistrationResponse> registrations = adminService.getAllCourseRegistrations();
        return ResponseEntity.ok(new ApiResponse<>(true, registrations, "All course registrations retrieved"));
    }

    @PostMapping("/course-registrations")
    @Operation(summary = "Force Register Course", description = "Allows admins to register a student for a course, bypassing normal validations (force=true).")
    public ResponseEntity<ApiResponse<CourseRegistrationResponse>> registerCourseWithForce(@Valid @RequestBody CourseRegistrationRequest request) {
        request.setForce(true); // Admin override
        CourseRegistrationResponse registration = registrationService.registerCourse(request);
        return new ResponseEntity<>(new ApiResponse<>(true, registration, "Course registered with force override"), HttpStatus.CREATED);
    }
    
    // COURSE OFFERINGS MANAGEMENT
    @GetMapping("/offerings")
    @Operation(summary = "Get Course Offerings", description = "Retrieves all offered courses for a given registration period.")
    public ResponseEntity<ApiResponse<List<CourseOffering>>> getOfferings(@RequestParam("period_id") UUID periodId) {
        List<CourseOffering> offerings = courseOfferingRepository.findByRegistrationPeriodId(periodId);
        return ResponseEntity.ok(new ApiResponse<>(true, offerings, "Offerings retrieved"));
    }

    @PostMapping("/offerings/bulk")
    @Operation(summary = "Add Course Offerings (Bulk)", description = "Adds multiple course offerings to a registration period by parsing a string of IDs.")
    public ResponseEntity<ApiResponse<List<CourseOffering>>> addOfferingsBulk(@RequestBody CourseOfferingBulkRequest request) {
        if (request.getCourseIds() == null || request.getCourseIds().trim().isEmpty()) {
            return new ResponseEntity<>(new ApiResponse<>(false, null, "Course IDs cannot be empty"), HttpStatus.BAD_REQUEST);
        }

        // Split by whitespace (spaces, tabs, newlines)
        String[] idsArray = request.getCourseIds().trim().split("\\s+");
        List<CourseOffering> savedOfferings = new ArrayList<>();

        for (String idStr : idsArray) {
            try {
                UUID courseId = UUID.fromString(idStr);
                
                CourseOffering offering = CourseOffering.builder()
                        .registrationPeriodId(request.getRegistrationPeriodId())
                        .courseId(courseId)
                        .maxSlots(request.getMaxSlots())
                        .availableSlots(request.getMaxSlots())
                        // Note: courseName and credits are left null. To be handled by another service.
                        .build();
                
                savedOfferings.add(courseOfferingRepository.save(offering));
            } catch (IllegalArgumentException e) {
                // Skip invalid UUIDs or log them
                System.out.println("Invalid UUID skipped: " + idStr);
            }
        }

        return new ResponseEntity<>(new ApiResponse<>(true, savedOfferings, savedOfferings.size() + " Offerings added"), HttpStatus.CREATED);
    }

    @DeleteMapping("/offerings/{id}")
    @Operation(summary = "Remove Course Offering", description = "Removes a course offering.")
    public ResponseEntity<ApiResponse<Void>> removeOffering(@PathVariable UUID id) {
        courseOfferingRepository.deleteById(id);
        return ResponseEntity.ok(new ApiResponse<>(true, null, "Offering removed"));
    }
}