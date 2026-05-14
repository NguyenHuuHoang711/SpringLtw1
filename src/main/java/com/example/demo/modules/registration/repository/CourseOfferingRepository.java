package com.example.demo.modules.registration.repository;

import com.example.demo.modules.registration.entity.CourseOffering;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface CourseOfferingRepository extends JpaRepository<CourseOffering, UUID> {
    List<CourseOffering> findByRegistrationPeriodId(UUID registrationPeriodId);
}