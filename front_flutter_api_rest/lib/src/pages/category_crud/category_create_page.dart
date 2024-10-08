import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_create.dart';
import 'package:front_flutter_api_rest/src/controller/categoryController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class CategoryCreatePage extends StatefulWidget {
  @override
  _CategoryCreatePageState createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _nombreController = TextEditingController();
  final _tagController = TextEditingController();

  String? selectedEstado;
  File? selectedImage;

  CategoryController categoryController = CategoryController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _crearCategoria() async {
    if (_formKey.currentState!.validate()) {
      String? downloadUrl = await _uploadImage(_nombreController.text);

      final nuevaCategoria = CategoriaModel(
        nombre: _nombreController.text,
        tag: _tagController.text,
        estado: selectedEstado ?? "",
        foto: downloadUrl ?? '', // Usar la URL de descarga de la imagen
      );

      try {
        final response =
            await categoryController.crearCategoria(nuevaCategoria);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Categoría creada con éxito')),
          );
          Navigator.pushNamed(context, AppRoutes.categoryListRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al crear la categoría: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error al crear la categoría: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la categoría: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(String title) async {
    try {
      if (selectedImage != null) {
        final fileName = 'venta/$title-${DateTime.now()}.png';
        final firebaseStorageReference =
            FirebaseStorage.instance.ref().child(fileName);

        await firebaseStorageReference.putFile(selectedImage!);
        final downloadUrl = await firebaseStorageReference.getDownloadURL();

        return downloadUrl;
      } else {
        return null;
      }
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }

  List<String> estados = [
    'Activo',
    'Inactivo',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarCreate(
              onBackTap: () {
                Navigator.pushNamed(context, AppRoutes.categoryListRoute);
              },
            ),
            SizedBox(height: 20), // Espacio entre la AppBar y el formulario
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo Nombre
                      TextFormField(
                        controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un nombre';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Campo Tag
                      TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: 'Tag',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el tag';
                          }
                          return null;
                        },
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
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona un estado';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Botón de seleccionar imagen
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image,color: Colors.white,),
                        label: Text('Seleccionar Imagen',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: HexColor("#F82249"),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedImage != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                      // Botón de crear categoría
                      ElevatedButton(
                        onPressed: _crearCategoria,
                        child: Text(
                          'Crear Item',
                          style: TextStyle(fontSize: 15,color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
      ),
    );
  }
}
