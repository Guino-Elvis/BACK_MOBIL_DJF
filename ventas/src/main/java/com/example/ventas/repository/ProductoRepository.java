package com.example.ventas.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ventas.entity.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    List<Producto> findBySubCategoriaId(Integer idSubCategoria);
}
