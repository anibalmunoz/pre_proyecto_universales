import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';

PreferredSizeWidget getCustomAppbar(
  BuildContext context, {
  required String? title,
  bool background = true,
  double elevation = 4,
  bool centerTitle = false,
  bool showButton = false,
  VoidCallback? onPressed,
  String contentButton = '',
}) {
  final isDark =
      (MediaQuery.of(context).platformBrightness == Brightness.light &&
              MyApp.themeNotifier.value == ThemeMode.dark) ||
          ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                  MyApp.themeNotifier.value == ThemeMode.system) ||
              (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                  MyApp.themeNotifier.value == ThemeMode.dark));

  return AppBar(
    centerTitle: centerTitle,
    title: Text(title ?? ""),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: isDark
          ? AppColor.shared.turquezaOscuro
          : AppColor.shared.turquezaClaro,
    ),
    backgroundColor:
        isDark ? AppColor.shared.turquezaOscuro : AppColor.shared.turquezaClaro,
    //elevation: elevation,
    actions: centerTitle
        ? showButton
            ? [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  // child: AddGroupButton(
                  //   verticalPadding: 6,
                  //   horizontalPadding: 13,
                  //   onTap: onPressed!,
                  //   content: contentButton,
                  //   textStyle: AppStyle.shared.fonts.smallButtonText,
                  // ),
                )
              ]
            : null
        : [
            Container(
              padding: const EdgeInsets.only(right: 15),
              alignment: Alignment.centerRight,
              // child: NormalButton(
              //   verticalPadding: 10,
              //   horizontalPadding: 15,
              //   onTap: () {},
              //   content:
              //       AppLocalizations.of(context).dictionary(Strings.textRules),
              //   textStyle: AppStyle.shared.fonts.smallButtonText,
              // ),
            )
          ],
  );
}
