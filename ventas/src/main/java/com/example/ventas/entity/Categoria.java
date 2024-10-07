package com.example.ventas.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

import lombok.Data;

@Entity
@Data
public class Categoria {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String nombre;
    private String tag;
    private String foto;
    private String estado;
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    private void preUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
