import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';

class GradientBack extends StatelessWidget {
  String title = "Popular";
  double altura = 0.0;

  GradientBack(
      {Key? key, required this.altura}); //heigt=null será un full screen

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    double screedHeight = MediaQuery.of(context).size.height;
    double screedWidht = MediaQuery.of(context).size.width;

    if (altura == double.infinity) {
      altura = screedHeight;
    }

    return Container(
      width: screedWidht,
      height: altura,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color.fromARGB(218, 46, 53, 52),
                      const Color.fromARGB(62, 57, 80, 73)
                    ]
                  : [
                      const Color.fromARGB(255, 212, 248, 245),
                      const Color.fromARGB(255, 252, 253, 253)
                    ],
              begin: const FractionalOffset(0.2, 0.0),
              end: const FractionalOffset(1.0, 0.6),
              stops: const [0.0, 0.6],
              tileMode: TileMode.clamp)),
      child: FittedBox(
        fit: BoxFit.none,
        alignment: const Alignment(-0.8, -0.8),
        child: Container(
          width: screedHeight,
          height: screedHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(5, 65, 70, 69),
            borderRadius: BorderRadius.circular(screedHeight / 2),
          ),
        ),
      ),
    );
  }
}
