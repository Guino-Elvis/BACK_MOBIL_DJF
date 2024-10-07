import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/pages/category_crud/category_list_page.dart';
import 'package:front_flutter_api_rest/src/pages/home/AdminHomePage.dart';


class AppRoutes {
  static const String homeRoute = '/';
  static const String categoryListRoute = '/crud_category_list'; 
  

  static Map<String, WidgetBuilder> getRoutes() {
    return {
     homeRoute: (context) => AdminHomePage(), 
     categoryListRoute: (context) => CategorylistPage(),   
     
     
    };
  }
}