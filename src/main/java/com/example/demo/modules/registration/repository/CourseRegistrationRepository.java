package com.example.demo.modules.registration.repository;

import com.example.demo.modules.registration.entity.CourseRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CourseRegistrationRepository extends JpaRepository<CourseRegistration, UUID> {
    // Maps to the courseClassId field in the entity
    Optional<CourseRegistration> findByStudentIdAndCourseClassIdAndRegistrationPeriodId(UUID studentId, UUID courseClassId, UUID registrationPeriodId);
    List<CourseRegistration> findByStudentId(UUID studentId);
    List<CourseRegistration> findByStudentIdAndRegistrationPeriodId(UUID studentId, UUID registrationPeriodId);
    long countByCourseClassIdAndStatus(UUID courseClassId, int status);
}