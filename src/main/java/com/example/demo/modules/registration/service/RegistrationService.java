
package com.example.demo.modules.registration.service;

import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.FocusCourseResponse;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;

import java.util.List;
import java.util.UUID;

public interface RegistrationService {
    List<RegistrationPeriodResponse> getActiveRegistrationPeriods();
    List<RegistrationPeriodResponse> getEligibleRegistrationPeriods(UUID studentId);
    List<FocusCourseResponse> getFocusCourses(UUID studentId);
    List<CourseRegistrationResponse> getMyRegistrations(UUID studentId);
    CourseRegistrationResponse registerCourse(CourseRegistrationRequest request);
    CourseRegistrationResponse cancelRegistration(UUID registrationId, UUID studentId);
    CourseRegistrationResponse reactivateRegistration(UUID registrationId, UUID studentId);
}
