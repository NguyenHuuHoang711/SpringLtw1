package com.example.demo.modules.registration.entity;

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
import jakarta.persistence.Version;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "course_registrations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@SQLRestriction("deleted_at IS NULL")
@SQLDelete(sql = "UPDATE course_registrations SET deleted_at = GETDATE() WHERE id = ?")
public class CourseRegistration {

    @Id
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "student_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID studentId;

    @Column(name = "course_class_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID courseClassId;

    @Column(name = "registration_period_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID registrationPeriodId;

    /**
     * 1: Học mới; 2: Học lại; 3: Cải thiện
     */
    @Column(name = "registration_type", nullable = false, columnDefinition = "TINYINT")
    private Integer registrationType;

    @Column(name = "replaced_grade_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID replacedGradeId;

    @Column(name = "registered_at", nullable = false)
    @Builder.Default
    private LocalDateTime registeredAt = LocalDateTime.now();

    /**
     * 1: Thành công; 2: Chờ thanh toán; 3: Đã hủy
     */
    @Column(name = "status", nullable = false, columnDefinition = "TINYINT")
    @Builder.Default
    private Integer status = 1;

    @Column(name = "is_paid", columnDefinition = "BIT")
    @Builder.Default
    private Boolean isPaid = false;

    @Version
    @Column(name = "row_version", insertable = false, updatable = false, columnDefinition = "timestamp")
    private byte[] rowVersion;

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
        if (this.registeredAt == null) this.registeredAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}