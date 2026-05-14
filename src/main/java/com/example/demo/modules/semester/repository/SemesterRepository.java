package com.example.demo.modules.semester.repository;

import com.example.demo.modules.semester.entity.Semester;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface SemesterRepository extends JpaRepository<Semester, UUID> {
}

