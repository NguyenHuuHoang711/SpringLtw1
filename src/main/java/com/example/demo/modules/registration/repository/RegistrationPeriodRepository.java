
package com.example.demo.modules.registration.repository;

import com.example.demo.modules.registration.entity.RegistrationPeriod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface RegistrationPeriodRepository extends JpaRepository<RegistrationPeriod, UUID> {
    List<RegistrationPeriod> findByIsActiveTrue();
}
