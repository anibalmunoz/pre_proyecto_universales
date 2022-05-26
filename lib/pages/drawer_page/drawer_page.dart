import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/settings_page/settings_page.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';
import 'package:pre_proyecto_universales/widgets/user_info.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatefulWidget {
  late GlobalBloc globalBloc;

  String? vista = MyApp.idioma;

  DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  UsuarioModel? user;

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    final authService = Provider.of<AuthService>(context);
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    UsuarioModel user = authService.getUsuario();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 30),
              child: UserInfo(user: user)),
          Divider(
            color: isDark ? Colors.white : Colors.black54,
          ),
          Container(
            margin: const EdgeInsets.only(top: 100, left: 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    localizations.dictionary(Strings.textAjustes),
                    style: AppStyle.shared.fonts.settingsText(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
