package com.example.ventas.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

import com.example.ventas.entity.Categoria;
import com.example.ventas.entity.SubCategoria;
import com.example.ventas.repository.SubCategoriaRepository;
import com.example.ventas.service.SubCategoriaService;
import io.swagger.v3.oas.annotations.servers.Server;

@Server
public class SubCategoriaServiceImpl implements SubCategoriaService {

    @Autowired
    private CategoriaServiceImpl categoriaService;

    @Autowired
    private SubCategoriaRepository subCategoriaRepository;

    @Override
    public List<SubCategoria> listar() {
        return subCategoriaRepository.findAll();
    }

    @Override
    public SubCategoria guardar(SubCategoria subCategoria) {
        return subCategoriaRepository.save(subCategoria);
    }

    @Override
    public SubCategoria actualizar(SubCategoria subCategoria) {
        return subCategoriaRepository.save(subCategoria);
    }

    @Override
    public Optional<SubCategoria> listarPorId(Integer id) {
        SubCategoria subCategoria = subCategoriaRepository.findById(id).orElse(null);
        if (subCategoria != null) {
            System.out.println("Antes de la petición");
            Optional<Categoria> categoriaOptional = categoriaService
                    .listarPorId(subCategoria.getCategoria().getId());
            if (categoriaOptional.isPresent()) {
                Categoria categoria = categoriaOptional.get();
                subCategoria.setCategoria(categoria);
            }
        }

        return Optional.ofNullable(subCategoria);
    }

    @Override
    public void eliminarPorId(Integer id) {
        subCategoriaRepository.deleteById(id);
    }

    @Override
    public List<SubCategoria> listarPorCategoria(Integer idCategoria) {
        // Obtener la lista de Productos por categoría directamente desde el
        // repositorio
        return subCategoriaRepository.findByCategoriaId(idCategoria);
    }
}
