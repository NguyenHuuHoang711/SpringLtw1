package com.example.demo.modules.registration.repository;

import com.example.demo.modules.registration.entity.RegistrationSupportRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface RegistrationSupportRequestRepository extends JpaRepository<RegistrationSupportRequest, UUID> {
    List<RegistrationSupportRequest> findByStudentIdOrderByCreatedAtDesc(UUID studentId);
    List<RegistrationSupportRequest> findAllByOrderByCreatedAtDesc();
}

