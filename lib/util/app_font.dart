import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';

class AppFont {
  static const _fontWorkSans = 'WorkSans';
  static const lato = 'lato';

  TextStyle LoginIntroduction(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TextStyle(
        fontSize: 25,
        color: isDark ? Colors.white : Colors.black,
        fontFamily: lato,
        fontWeight: FontWeight.normal);
  }

  TextStyle settingsText(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return TextStyle(
      fontSize: 20,
      // color: isDark
      //     ? AppColor.shared.turquezaOscuro
      //     : AppColor.shared.turquezaClaro,
      // fontFamily: _fontWorkSans,
      // fontWeight: FontWeight.w700
    );
  }
}
