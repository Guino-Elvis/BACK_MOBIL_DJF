import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/pages/category_crud/category_list_page.dart';
import 'package:front_flutter_api_rest/src/pages/home/AdminHomePage.dart';
import 'package:front_flutter_api_rest/src/pages/home/HomePage.dart';
import 'package:front_flutter_api_rest/src/pages/home/UserHomePage.dart';
import 'package:front_flutter_api_rest/src/pages/home/loginPage.dart';
import 'package:front_flutter_api_rest/src/pages/home/registerPage.dart';
import 'package:front_flutter_api_rest/src/pages/home/welcome.dart';


class AppRoutes {
//  static const String welcomeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  // static const String homeRoute = '/home';
  static const String homeRoute = '/';
  static const String userhomeRoute = '/user_home';
  static const String adminhomeRoute = '/admin_home';
  static const String categoryListRoute = '/crud_category_list';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // welcomeRoute: (context) => WelcomePage(),
      loginRoute: (context) => LoginPage(),
      registerRoute: (context) => RegisterPage(),
      homeRoute: (context) => HomePage(),
      userhomeRoute: (context) => UserHomePage(),
      adminhomeRoute: (context) => AdminHomePage(),
      categoryListRoute: (context) => CategorylistPage(),
    };
  }
}