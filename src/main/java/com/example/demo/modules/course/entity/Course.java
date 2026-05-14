package com.example.demo.modules.course.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "courses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@SQLRestriction("deleted_at IS NULL")
@SQLDelete(sql = "UPDATE courses SET deleted_at = GETDATE() WHERE id = ?")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "department_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID departmentId;

    @Column(name = "code", length = 20)
    private String code;

    @Column(name = "name", columnDefinition = "NVARCHAR(255)")
    private String name;

    @Column(name = "name_en", columnDefinition = "NVARCHAR(255)")
    private String nameEn;

    @Column(name = "credits", precision = 5, scale = 1)
    private BigDecimal credits;

    @Column(name = "course_type", length = 20)
    private String courseType;

    @Column(name = "theory_hours", precision = 5, scale = 1)
    private BigDecimal theoryHours;

    @Column(name = "practice_hours", precision = 5, scale = 1)
    private BigDecimal practiceHours;

    @Column(name = "self_study_hours", precision = 5, scale = 1)
    private BigDecimal selfStudyHours;

    @Column(name = "internship_credits", precision = 5, scale = 1)
    private BigDecimal internshipCredits;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(name = "created_at", updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "created_by", updatable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID createdBy;

    @Column(name = "updated_by", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID updatedBy;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "deleted_by", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID deletedBy;

    @Column(name = "is_active", columnDefinition = "BIT")
    @Builder.Default
    private Boolean isActive = true;
}