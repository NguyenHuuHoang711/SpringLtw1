package com.example.demo.modules.registration.entity;

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

import java.util.UUID;

@Entity
@Table(name = "course_offerings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CourseOffering {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "registration_period_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID registrationPeriodId;

    @Column(name = "course_id", nullable = false, columnDefinition = "UNIQUEIDENTIFIER")
    private UUID courseId;

    // Optional fields. We can let another service handle the display names/credits.
    @Column(name = "course_name")
    private String courseName;

    @Column(name = "credits")
    private Integer credits; // Use Integer so it can be nullable

    @Column(name = "available_slots")
    private Integer availableSlots;

    @Column(name = "max_slots")
    private Integer maxSlots;
}
