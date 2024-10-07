import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/delete_item.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/pages/category_crud/category_create_page.dart';
import 'package:front_flutter_api_rest/src/pages/category_crud/category_edit_page.dart';
import 'package:front_flutter_api_rest/src/controller/categoryController.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';

class CategorylistPage extends StatefulWidget {
  @override
  _CategorylistPageState createState() => _CategorylistPageState();
}

class _CategorylistPageState extends State<CategorylistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CategoriaModel> item = [];
  CategoryController categoryController = CategoryController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final categoriesData = await categoryController.getDataCategories();
      setState(() {
        item = categoriesData
            .map<CategoriaModel>((json) => CategoriaModel.fromJson(json))
            .toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> _removeCategory(int id, String fotoURL) async {
    final response = await categoryController.removeCategoria(id, fotoURL);

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría eliminada con éxito')),
      );
      _getData();
    } else if (response.statusCode == 500) {
      // Mensaje específico para el error 500
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al eliminar la categoría: tiene elementos relacionados.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría.')),
      );
    }
  }

  void _showDeleteDialog(int id, String fotoURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          id: id,
          fotoURL: fotoURL, // Asegúrate de pasar la URL aquí
          onConfirmDelete: _removeCategory, // Esto ahora está correcto
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(ConfigApi.appName),
      ),
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: item.map<Widget>((category) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(category.nombre ?? 'No Name'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  // Usar CachedNetworkImage para cargar la imagen de la categoría
                                  CachedNetworkImage(
                                    imageUrl:
                                        category.foto ?? '', // URL de la foto
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius:
                                          50, // Ajusta el tamaño según sea necesario
                                    ),
                                    placeholder: (context, url) => CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/nofoto.jpg'),
                                      radius:
                                          50, // Tamaño del avatar por defecto
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/nofoto.jpg'), // Imagen por defecto en caso de error
                                      radius: 50,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryEditPage(
                                        item: category,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Editar '),
                              ),
                              ElevatedButton(
                                onPressed: () => _showDeleteDialog(
                                    category.id!, category.foto!),
                                child: Text('Eliminar '),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
