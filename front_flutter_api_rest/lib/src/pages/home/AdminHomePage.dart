// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';



class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  
  }
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
           
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        ),
      ],
    ),
    drawer: NavigationDrawerWidget(),
    backgroundColor: Colors.grey[200],
    body: Column(
      children: [
        Container(
          child: Text('holaaa'),
        )
      ],
    ),
  );
}



}
