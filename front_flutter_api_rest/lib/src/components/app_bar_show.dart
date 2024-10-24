import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AppBarShow extends StatelessWidget {
  final VoidCallback? onBackTap;
  final String title;

  const AppBarShow({Key? key, this.onBackTap, this.title = 'No hay titulo'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      color:  themeProvider.isDiurno ? themeColors[2] : themeColors[0],
      padding: EdgeInsets.only(left: 2, right: 2),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap ??
                () {
                  Navigator.pop(context);
                },
            child: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: () {
                // Al tocar la imagen, aparece el menú
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(1000, 70, 10, 10),
                  items: [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Perfil"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Configuración"),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("Cerrar sesión"),
                    ),
                  ],
                ).then((value) {
                  if (value != null) {
                    _onMenuOptionSelected(context, value);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://tse1.mm.bing.net/th?id=OIP.5TupH3c6D-Ma65KuMnEsOwHaJP&pid=Api&P=0&h=180',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMenuOptionSelected(BuildContext context, int value) {
    switch (value) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil seleccionado')),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuración seleccionada')),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cerrar sesión seleccionado')),
        );
        break;
    }
  }
}
