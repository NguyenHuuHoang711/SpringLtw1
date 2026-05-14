
package com.example.demo.modules.course.repository;

import com.example.demo.modules.course.entity.EquivalentCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface EquivalentCourseRepository extends JpaRepository<EquivalentCourse, UUID> {
    @Query("SELECT ec.originalCourseId FROM EquivalentCourse ec WHERE ec.equivalentCourseId = :courseId AND ec.equivalenceType = 1 AND ec.isActive = true")
    List<UUID> findReplacedCourses(@Param("courseId") UUID courseId);

    @Query("SELECT ec.equivalentCourseId FROM EquivalentCourse ec WHERE ec.originalCourseId = :courseId AND ec.equivalenceType = 1 AND ec.isActive = true")
    List<UUID> findReplacingCourses(@Param("courseId") UUID courseId);
}
