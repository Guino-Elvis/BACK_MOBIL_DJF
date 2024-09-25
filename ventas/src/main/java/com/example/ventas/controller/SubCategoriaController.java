package com.example.ventas.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ventas.entity.SubCategoria;
import com.example.ventas.service.SubCategoriaService;

import java.util.List;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/subcategoria")
public class SubCategoriaController {
    @Autowired
    private SubCategoriaService subCategoriaService;

    @GetMapping()
    public ResponseEntity<List<SubCategoria>> list() {
        return ResponseEntity.ok().body(subCategoriaService.listar());
    }

    @PostMapping()
    public ResponseEntity<SubCategoria> save(@RequestBody SubCategoria subCategoria) {
        return ResponseEntity.ok(subCategoriaService.guardar(subCategoria));
    }

    @PutMapping()
    public ResponseEntity<SubCategoria> update(@RequestBody SubCategoria subCategoria) {
        return ResponseEntity.ok(subCategoriaService.actualizar(subCategoria));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SubCategoria> listById(@PathVariable(required = true) Integer id) {
        return ResponseEntity.ok().body(subCategoriaService.listarPorId(id).get());
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable(required = true) Integer id) {
        subCategoriaService.eliminarPorId(id);
        return "Eliminacion Correcta";
    }
}