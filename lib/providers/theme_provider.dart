import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      backgroundColor: Colors.grey.shade900,
      appBarTheme:
          AppBarTheme(backgroundColor: AppColor.shared.turquezaOscuro));
  static final lightTheme = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: AppColor.shared.turquezaClaro));
}
