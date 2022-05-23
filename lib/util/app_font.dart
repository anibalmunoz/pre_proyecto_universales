import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';

class AppFont {
  static const _fontWorkSans = 'WorkSans';
  static const lato = 'lato';

  TextStyle LoginIntroduction(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                MyApp.themeNotifier.value == ThemeMode.system));
    return TextStyle(
        fontSize: 25,
        color: isDark ? Colors.white : Colors.black,
        fontFamily: lato,
        fontWeight: FontWeight.normal);
  }

  TextStyle settingsText(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                MyApp.themeNotifier.value == ThemeMode.system));
    return const TextStyle(
      fontSize: 20,
    );
  }

  TextStyle inputText(BuildContext context) {
    return const TextStyle(fontSize: 18, fontFamily: lato);
  }
}
