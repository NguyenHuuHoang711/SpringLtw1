package com.example.demo.modules.semester.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.UUID;

@Data
@Entity
@Table(name = "semesters")
public class Semester {
    @Id
    @Column(name = "id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "code", length = 50)
    private String code;

    @Column(name = "name", columnDefinition = "NVARCHAR(100)")
    private String name;

    @Column(name = "school_year_id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID schoolYearId;
}

