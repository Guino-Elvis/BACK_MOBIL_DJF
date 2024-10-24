import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class ThemeProvider extends ChangeNotifier {
  bool _isDiurno = true;

  bool get isDiurno => _isDiurno;

  void toggleTheme() {
    _isDiurno = !_isDiurno;
    notifyListeners();
  }

  static Color bluePersonalizado_0 = HexColor("#2b96ed");
  static Color fondodark_1 = HexColor("#1A1B1F");
  static Color fondodarkcard_2 = HexColor("#161719");
  static Color color3 = Colors.orange;
  static Color color4 = Colors.purple;
  static Color color5 = Colors.yellow;
  static Color color6 = Colors.black;
  static Color color7 = Colors.white;
  static Color color8 = Colors.transparent;
  static Color color9 = Colors.white12;
  static Color color10 = Colors.black12;
 

  
  List<Color> diatheme() {
    return [bluePersonalizado_0, fondodark_1, fondodarkcard_2, color3,color4, color5, color6, color7,color8,color9,color10]; 
  }

  List<Color> nochetheme() {
    return [bluePersonalizado_0, fondodark_1, fondodarkcard_2, color3,color4, color5, color6, color7,color8,color9,color10];
  }

  List<Color> getThemeColors() {
    return _isDiurno ? diatheme() : nochetheme();
  }
}