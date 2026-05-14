
package com.example.demo.modules.course.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

// Lightweight repository for course_classes used by the demo frontend
@Repository
public interface CourseClassRepository extends JpaRepository<com.example.demo.modules.course.entity.CourseClass, UUID> {
	List<com.example.demo.modules.course.entity.CourseClass> findByAcademicYearId(UUID academicYearId);
}
