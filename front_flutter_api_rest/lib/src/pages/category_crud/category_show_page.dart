import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_show.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class CategoryShowPage extends StatefulWidget {
  final CategoriaModel item;

  CategoryShowPage({required this.item});

  @override
  _CategoryShowPageState createState() => _CategoryShowPageState();
}

class _CategoryShowPageState extends State<CategoryShowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F82249"),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppBarShow(
              onBackTap: () {
                Navigator.pushNamed(context, AppRoutes.categoryListRoute);
              },
              title: widget.item.nombre?.toString() ?? 'no hay nombre',
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.item.foto.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/nofoto.jpg'),
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  Container(
                    width: 160,
                    child: Center(
                        child: Text(
                      widget.item.nombre?.toString().toUpperCase() ??
                          'no hay nombre',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
            Container(
              child: ClipPath(
                clipper: WaveClipperOne(reverse: true),
                child: Container(
                 height: 520,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Establecer la altura según la pantalla
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 90),
                        ClipPath(
                          clipper: WaveClipperOne(reverse: true),
                          child: Container(
                            width: 380,
                            padding: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Estado de la categoria:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.estado.toString() ??
                                          'no hay estado',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Nombre de la categoria:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.nombre.toString() ??
                                          'no hay tag',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Tag de la categoria:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.tag.toString() ??
                                          'no hay tag',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: HexColor("#F82249"),
                                borderRadius: BorderRadius.circular(150)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipPath(
                            clipper: SideCutClipper(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de Creación',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Espaciado entre el texto y la fecha
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.createdAt != null
                                                  ? DateFormat('dd/MM/yyyy').format(
                                                      DateTime.parse(widget.item
                                                          .createdAt!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time, // Icono de la hora
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.createdAt != null
                                                  ? DateFormat('HH:mm').format(
                                                      DateTime.parse(widget.item
                                                          .createdAt!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                      color: HexColor("#F82249"),
                                      borderRadius: BorderRadius.circular(150)),
                              ),
                            ),
                              ClipPath(
                            clipper: SideCutClipper(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de Actualización',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Espaciado entre el texto y la fecha
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.updatedAt != null
                                                  ? DateFormat('dd/MM/yyyy').format(
                                                      DateTime.parse(widget.item
                                                          .updatedAt!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time, // Icono de la hora
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.updatedAt != null
                                                  ? DateFormat('HH:mm').format(
                                                      DateTime.parse(widget.item
                                                          .updatedAt!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                      color: HexColor("#F82249"),
                                      borderRadius: BorderRadius.circular(150)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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