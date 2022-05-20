import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/pages/login_pages/login_form.dart';

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

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _firebase;

  Future<void> inicializarFirebase() async {
    await Firebase.initializeApp();
    await _inicializarCrashlytics();
    //await _inicializarRealtimeDatabase();
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

  @override
  void initState() {
    super.initState();
    _firebase = inicializarFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginForm(),
    );
  }
}
