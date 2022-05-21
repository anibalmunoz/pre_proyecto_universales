import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';

class FABPersonal extends StatelessWidget {
  VoidCallback onPressed;
  FABPersonal({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark ||
            MyApp.themeNotifier.value == ThemeMode.dark;

    return FloatingActionButton(
      backgroundColor: isDark
          ? AppColor.shared.turquezaOscuro
          : AppColor.shared.turquezaClaro,
      onPressed: onPressed,
      child: const Icon(
        Icons.message,
        color: Colors.white,
      ),
    );
  }
}
