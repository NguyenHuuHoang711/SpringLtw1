package com.example.demo.modules.grade.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.UUID;

@Data
@Entity
@Table(name = "grade")
public class Grade {
    @Id
    @Column(name = "id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;
    
    @Column(name = "student_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID studentId;
    
    @Column(name = "course_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID courseId;
    
    @Column(name = "grade")
    private Double grade;
}