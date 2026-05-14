package com.example.demo.modules.department.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.util.UUID;

@Data
@Entity
@Table(name = "departments")
public class Department {
    @Id
    @Column(name = "id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "code", length = 50)
    private String code;

    @Column(name = "name", columnDefinition = "NVARCHAR(100)")
    private String name;
}

