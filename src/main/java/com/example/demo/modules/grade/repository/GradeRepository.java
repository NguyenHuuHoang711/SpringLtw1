package com.example.demo.modules.grade.repository;

import com.example.demo.modules.grade.entity.Grade;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface GradeRepository extends JpaRepository<Grade, UUID> {
    List<Grade> findByStudentId(UUID studentId);
}
