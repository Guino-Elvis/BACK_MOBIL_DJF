import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/controller/categoryController.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';
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
        estado:selectedEstado ?? "",
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
      appBar: AppBar(
        title: Text(ConfigApi.appName),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.categoryListRoute);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tagController,
                decoration: InputDecoration(labelText: 'tag'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tag';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedEstado,
                onChanged: (String? newValue) {
                  // Aquí puedes manejar el cambio de valor seleccionado
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
                  hintText: 'Selecciona un Estado par el Item',
                  icon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el estado';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              if (selectedImage != null) Image.file(selectedImage!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearCategoria,
                child: Text('Crear Categoría'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
