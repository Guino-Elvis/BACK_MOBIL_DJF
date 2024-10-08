import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/categoryController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/providers/provider.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:hexcolor/hexcolor.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor para mostrar la imagen con un estilo mejorado
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: widget.item.foto.toString(),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/nofoto.jpg'),
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            SizedBox(height: 20), // Espaciado entre imagen y formulario
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de texto para el nombre
                      TextFormField(
                        controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Espaciado entre campos
                      // Campo de texto para el tag
                      TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: 'Tag',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Dropdown de Estado
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
                          labelText: 'Estado',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: HexColor("#F82249")),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Botón para seleccionar una imagen
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image),
                        label: Text('Seleccionar Imagen'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedImage != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                      // Botón para actualizar la categoría
                      ElevatedButton(
                        onPressed: _editarCategoria,
                        child: Text(
                          'Actualizar Categoría',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
