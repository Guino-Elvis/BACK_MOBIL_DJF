import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/categoryController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/providers/provider.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';

class CategoryEditPage extends StatefulWidget {
  final CategoriaModel item;

  CategoryEditPage({required this.item});

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _nombreController = TextEditingController();
  final _tagController = TextEditingController();
  String? selectedEstado;
  File? selectedImage; // Para almacenar la imagen seleccionada
  CategoryController categoryController = CategoryController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.item.nombre ?? '';
    _tagController.text = widget.item.tag ?? '';
    selectedEstado = widget.item.estado ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path); // Asigna la imagen seleccionada
      });
    }
  }

  void _editarCategoria() async {
    String newImageUrl = widget.item.foto ?? "";
    int? itemId = widget.item.id;
    String title = widget.item.nombre.toString();

    // Subir la nueva imagen si se ha seleccionado una
    if (selectedImage != null) {
      String fileName = 'venta/$itemId-$title.png';
      final firebaseStorageReference =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        await firebaseStorageReference.putFile(selectedImage!);
        final downloadUrl = await firebaseStorageReference.getDownloadURL();

        if (downloadUrl != null) {
          newImageUrl = downloadUrl; // Actualizar URL de la imagen
        }
      } catch (e) {
        print("Error al cargar la imagen: $e");
      }
    }

    final editedCategory = CategoriaModel(
      id: widget.item.id, // Usa el id del ítem existente
      nombre: _nombreController.text,
      tag: _tagController.text,
      estado: selectedEstado ?? "",
      foto: newImageUrl, // Usa la URL nueva o la existente
    );

    final response = await categoryController.editarCategoria(editedCategory);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría actualizada con éxito')),
      );
      Navigator.pushNamed(context, AppRoutes.categoryListRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la categoría')),
      );
    }
  }

  List<String> estados = ['Activo', 'Inactivo'];

  @override
  Widget build(BuildContext context) {
    // final urls = Providers.provider();
    // final urlString = urls['fotosback']!;

    // final imageUrl = widget.item.foto != null && widget.item.foto!.isNotEmpty
    //     ? urlString + widget.item.foto!
    //     : 'assets/nofoto.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Editar Categoría: ${widget.item.nombre ?? 'Sin Nombre'}'), // Muestra 'Sin Nombre' si el nombre es nulo
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.item.foto.toString(),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/nofoto.jpg'),
                fit: BoxFit.cover,
              ),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _tagController,
                decoration: InputDecoration(labelText: 'Tag'),
              ),
              DropdownButtonFormField<String>(
                value: selectedEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEstado = newValue;
                  });
                },
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Formato',
                  hintText: 'Selecciona un estado para este item',
                  icon: Icon(Icons.category_outlined),
                ),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              if (selectedImage != null)
                Image.file(selectedImage!), // Muestra la imagen seleccionada
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editarCategoria,
                child: Text('Actualizar Categoría'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
