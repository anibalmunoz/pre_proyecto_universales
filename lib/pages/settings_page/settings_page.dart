import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  late GlobalBloc globalBloc;
  late String idiomaBox;
  late String temaBox;
  late GlobalBloc basicBloc;

  String? vista = MyApp.idioma;

  String? vistaLang = MyApp.themeNotifier.value.toString();

  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    widget.basicBloc = BlocProvider.of<GlobalBloc>(context);

    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    widget.idiomaBox = localizations.dictionary(Strings.dispositivo);
    widget.temaBox = localizations.dictionary(Strings.dispositivo);

    final authService = Provider.of<AuthService>(context);

    var listaIdiomas = [widget.idiomaBox, "Español", "English"];
    var listaTemas = [
      widget.temaBox,
      localizations.dictionary(Strings.claro),
      localizations.dictionary(Strings.oscuro)
    ];

    return Scaffold(
      appBar: getCustomAppbar(context,
          title: localizations.dictionary(Strings.textAjustes)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 22.0),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 20),
                      child: Text(
                        localizations.dictionary(Strings.labelCambiarTema),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 10),
                      child: DropdownButton(
                        items: listaTemas.map((String a) {
                          return DropdownMenuItem(value: a, child: Text(a));
                        }).toList(),
                        onChanged: (value) async {
                          if (value.toString() ==
                              localizations.dictionary(Strings.dispositivo)) {
                            await cambiarASystemSharedPref();
                            MyApp.themeNotifier.value = ThemeMode.system;
                          } else if (value.toString() ==
                              localizations.dictionary(Strings.claro)) {
                            await cambiarALightSharedPref();
                            MyApp.themeNotifier.value = ThemeMode.light;
                          } else if (value.toString() ==
                              localizations.dictionary(Strings.oscuro)) {
                            await cambiarADarkSharedPref();
                            MyApp.themeNotifier.value = ThemeMode.dark;
                          }
                          setState(
                            () {
                              widget.vistaLang = value.toString();
                            },
                          );
                        },
                        hint: widget.vistaLang == 'ThemeMode.system'
                            ? Text(
                                localizations.dictionary(Strings.dispositivo))
                            : widget.vistaLang == 'ThemeMode.light'
                                ? Text(
                                    localizations.dictionary(Strings.claro),
                                  )
                                : widget.vistaLang == 'ThemeMode.dark'
                                    ? Text(localizations
                                        .dictionary(Strings.oscuro))
                                    : Text(widget.vistaLang!),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 22),
                  child: const Icon(
                    Icons.language,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 35, left: 10),
                      child: Text(
                        localizations
                            .dictionary(Strings.labelSeleccionarOtroIdioma),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, top: 10),
                      child: DropdownButton(
                        items: listaIdiomas.map((String a) {
                          return DropdownMenuItem(value: a, child: Text(a));
                        }).toList(),
                        onChanged: (value) async => {
                          await guardarIdiomaEnSharedPreferences(
                              value.toString()),
                          setState(() {
                            widget.vista = value.toString();
                          }),
                        },
                        hint: widget.vista != 'null' &&
                                widget.vista != "Dispositivo" &&
                                widget.vista != "Device"
                            ? Text(widget.vista!)
                            : Text(
                                localizations.dictionary(Strings.dispositivo)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15.0, top: 55),
                  child: IconButton(
                    onPressed: () async {
                      // widget.basicBloc.add(DeslogueadoEvent());
                      await authService.signOut();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 55),
                  child: Text(
                    localizations.dictionary(Strings.labelCerrarCesion),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> guardarIdiomaEnSharedPreferences(String lengua) async {
    String idioma = lengua;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (idioma == 'Dispositivo' || idioma == 'Device') {
      await prefs.setString("idioma", 'Device');
      MyApp.idioma = 'null';
    } else {
      await prefs.setString("idioma", idioma);
      MyApp.idioma = idioma;
    }
  }

  static Future<void> cambiarALightSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tema", "ThemeMode.light");
  }

  static Future<void> cambiarADarkSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tema", "ThemeMode.dark");
  }

  static Future<void> cambiarASystemSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tema", "ThemeMode.system");
  }
}
