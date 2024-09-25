package com.example.ventas.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ventas.entity.SubCategoria;

public interface SubCategoriaRepository extends JpaRepository<SubCategoria, Integer> {
    List<SubCategoria> findByCategoriaId(Integer idCategoria);
}
