import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/pages/loading_page/loading_screen.dart';
import 'package:pre_proyecto_universales/pages/login_pages/login_form.dart';
import 'package:pre_proyecto_universales/pages/splash_page/splash_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(
      () => runApp(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => GlobalBloc(),
                  child: Container(),
                )
              ],
              child: const MyApp(),
            ),
          ),
      (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  static final ValueNotifier<ThemeMode> tema = ValueNotifier(ThemeMode.system);

  static String? idioma = "";

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _firebase;

  Future<void> inicializarFirebase() async {
    await Firebase.initializeApp();
    await _inicializarCrashlytics();
    //await _inicializarRealtimeDatabase();
    await _seleccionarIdiomaDeSharedPreferences();
    await _seleccionarTemaDeSharedPreferences();
  }

  Future<void> _inicializarCrashlytics() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    Function onOriginalError = FlutterError.onError as Function;
    FlutterError.onError = (FlutterErrorDetails detallesDeError) async {
      await FirebaseCrashlytics.instance.recordFlutterError(detallesDeError);
      onOriginalError(detallesDeError);
    };
  }

  Future<void> _inicializarRealtimeDatabase() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("modo");
    // ref.onValue.listen(
    //   (DatabaseEvent event) {
    //     final data = event.snapshot.value;
    //     print("LA DATA OBTENIDA ES: ${data}");
    //     // if (data.toString() == "{modo: ThemeMode.light}") {
    //     //   MyApp.themeNotifier.value = ThemeMode.light;
    //     // } else {
    //     //   MyApp.themeNotifier.value = ThemeMode.dark;
    //     // }
    //   },
    // );
  }

  Future<void> _seleccionarIdiomaDeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lenguaje = prefs.getString("idioma");
    if (lenguaje != null) {
      MyApp.idioma = lenguaje;
    } else if (lenguaje == null || lenguaje == 'Device') {
      MyApp.idioma = 'null';
    }
  }

  Future<void> _seleccionarTemaDeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tema = prefs.getString("tema");
    if (tema == 'ThemeMode.system') {
      MyApp.themeNotifier.value = ThemeMode.system;
    } else if (tema == 'ThemeMode.light') {
      MyApp.themeNotifier.value = ThemeMode.light;
    } else if (tema == 'ThemeMode.dark') {
      MyApp.themeNotifier.value = ThemeMode.dark;
    }
  }

  @override
  void initState() {
    super.initState();
    _firebase = inicializarFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: MyApp.themeNotifier,
            builder: (_, ThemeMode currentMode, __) {
              return MaterialApp(
                supportedLocales: const [
                  Locale('es'),
                  Locale('en'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                themeMode: currentMode,
                theme: ThemeData.light(), //MyThemes.lightTheme,
                darkTheme: ThemeData.dark(), //MyThemes.darkTheme,
                home: const LoadingScreen(),
              );
            },
          );
        } else {
          return const SplashPage();
        }
      },
    );
  }
}
