
package com.example.demo.modules.registration.service;

import com.example.demo.modules.registration.request.EquivalentCourseRequest;
import com.example.demo.modules.registration.request.RegistrationPeriodRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.EquivalentCourseResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;

import java.util.List;
import java.util.UUID;

public interface AdminRegistrationService {
    // Registration Period Management
    RegistrationPeriodResponse createRegistrationPeriod(RegistrationPeriodRequest request);
    RegistrationPeriodResponse updateRegistrationPeriod(UUID id, RegistrationPeriodRequest request);
    void deleteRegistrationPeriod(UUID id);
    List<RegistrationPeriodResponse> getAllRegistrationPeriods();
    RegistrationPeriodResponse getRegistrationPeriodById(UUID id);

    // Equivalent Course Management
    EquivalentCourseResponse createEquivalentCourse(EquivalentCourseRequest request);
    EquivalentCourseResponse updateEquivalentCourse(UUID id, EquivalentCourseRequest request);
    void deleteEquivalentCourse(UUID id);
    List<EquivalentCourseResponse> getAllEquivalentCourses();
    EquivalentCourseResponse getEquivalentCourseById(UUID id);

    // Course Registration Management
    List<CourseRegistrationResponse> getAllCourseRegistrations();
}
