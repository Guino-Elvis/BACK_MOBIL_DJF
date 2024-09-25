package com.example.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ventas.entity.Categoria;

public interface CategoriaRepository extends JpaRepository<Categoria, Integer> {

}
