package com.example.demo.modules.course.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "equivalent_courses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@SQLRestriction("deleted_at IS NULL")
@SQLDelete(sql = "UPDATE equivalent_courses SET deleted_at = GETDATE() WHERE id = ?")
public class EquivalentCourse {

    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "original_course_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID originalCourseId;

    @Column(name = "equivalent_course_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID equivalentCourseId;

    /**
     * 1: Thay thế hoàn toàn; 2: Tương đương song song
     */
    @Column(name = "equivalence_type", nullable = false, columnDefinition = "TINYINT")
    private Integer equivalenceType;

    @Column(name = "effect_date", columnDefinition = "DATE")
    private LocalDate effectDate;

    @Column(name = "is_active", columnDefinition = "BIT")
    @Builder.Default
    private Boolean isActive = true;

    @Column(name = "note", length = 500, columnDefinition = "NVARCHAR(500)")
    private String note;

    // --- Audit Fields ---

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

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

    // --- Lifecycle Hooks ---

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.isActive == null) this.isActive = true;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}