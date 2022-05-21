import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/pages/settings_page/settings_page.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';

class DrawerPage extends StatefulWidget {
  late GlobalBloc globalBloc;
  late String idiomaBox;

  String? vista = MyApp.idioma;

  DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    widget.idiomaBox = localizations.dictionary(Strings.dispositivo);

    var listaIdiomas = [widget.idiomaBox, "Español", "English"];

    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 300, left: 10),
              child: Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Ajustes',
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
