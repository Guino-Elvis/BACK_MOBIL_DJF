package com.example.ventas.repository;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ventas.entity.Categoria;
import java.util.List;

public interface CategoriaRepository extends JpaRepository<Categoria, Integer> {

    // funcion para buscar
    List<Categoria> findByBusqueda(
            String nombre,
            LocalDateTime fechaInicio,
            LocalDateTime fechaFin,
            String estado);
}
