import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Color appBarColor; 


  AppBarComponent({required this.appBarColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      leading: IconButton(
        icon: Icon(Icons.menu ,color: Colors.white,), // Icono del drawer
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Abrir el drawer
        },
      ),
      
      actions: [
       
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: GestureDetector(
            onTap: () {
           
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
            child: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                'https://tse1.mm.bing.net/th?id=OIP.5TupH3c6D-Ma65KuMnEsOwHaJP&pid=Api&P=0&h=180', // URL de la imagen de perfil
              ),
            ),
          ),
        ),
      ],
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

 
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); 
}
