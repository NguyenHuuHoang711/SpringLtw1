package com.example.demo.modules.registration.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import org.hibernate.type.SqlTypes;

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

/**
 * Entity đại diện cho bảng registration_periods
 * Cập nhật theo chuẩn Hibernate 6.3+ (SQLRestriction) và 6.5+ (UUID Generation)
 */
@Entity
@Table(name = "registration_periods")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
// Thay thế @Where bằng @SQLRestriction
@SQLRestriction("deleted_at IS NULL")
// Giữ nguyên @SQLDelete vì nó vẫn là phương thức chuẩn để xử lý Soft Delete
@SQLDelete(sql = "UPDATE registration_periods SET deleted_at = GETDATE() WHERE id = ?")
public class RegistrationPeriod {

    @Id
    /*
       Trong Hibernate 6, việc generate UUID đơn giản hơn rất nhiều.
       Không cần @GenericGenerator cũ kỹ nữa.
    */
    @GeneratedValue
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "name", nullable = false, length = 200)
    private String name;

    @Column(name = "semester_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID semesterId;

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    /**
     * Sử dụng JdbcTypeCode để map NVARCHAR(MAX) hoặc JSON một cách tường minh hơn
     */
    @JdbcTypeCode(SqlTypes.NVARCHAR)
    @Column(name = "target_config", columnDefinition = "NVARCHAR(MAX)")
    private String targetConfig;

    @Column(name = "max_credits", nullable = false, columnDefinition = "TINYINT")
    @Builder.Default
    private Integer maxCredits = 25;

    @Column(name = "min_credits", nullable = false, columnDefinition = "TINYINT")
    @Builder.Default
    private Integer minCredits = 12;

    @Column(name = "allow_retake", columnDefinition = "BIT")
    @Builder.Default
    private Boolean allowRetake = true;

    @Column(name = "is_active", columnDefinition = "BIT")
    @Builder.Default
    private Boolean isActive = true;

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
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}