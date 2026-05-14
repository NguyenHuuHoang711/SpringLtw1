
package com.example.demo.modules.course.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.UUID;

// Lightweight mapping for course_classes table used by the demo frontend and registration flows
@Data
@Entity
@Table(name = "course_classes")
public class CourseClass {
    @Id
    @Column(name = "id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "course_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID courseId;

    @Column(name = "academic_year_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID academicYearId;

    @Column(name = "credits")
    private Integer credits;

    @Column(name = "description", columnDefinition = "NVARCHAR(255)")
    private String description;

    @Column(name = "max_students")
    private Integer maxStudents;

    @Column(name = "available_slots")
    private Integer availableSlots;
}
