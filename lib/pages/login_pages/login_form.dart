import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/sign_up_page/sign_up.dart';
import 'package:pre_proyecto_universales/providers/fingerprint.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';
import 'package:pre_proyecto_universales/widgets/button_personal.dart';
import 'package:pre_proyecto_universales/widgets/gradient_back.dart';
import 'package:pre_proyecto_universales/widgets/widget_input_text.dart';
import 'package:pre_proyecto_universales/widgets/widget_logo.dart';
import 'package:provider/provider.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/local_auth.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var correoController = TextEditingController();
  var contrasenaController = TextEditingController();
  static GlobalBloc? globalBloc;
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    globalBloc = BlocProvider.of<GlobalBloc>(context);
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return Scaffold(
      body: Stack(
        children: [
          GradientBack(altura: double.infinity),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Logo(height: MediaQuery.of(context).size.height * .25),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            localizations.dictionary(Strings.textBienvenido),
                            textAlign: TextAlign.center,
                            style: AppStyle.shared.fonts
                                .LoginIntroduction(context),
                          )),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            InputText(
                              labelText: localizations
                                  .dictionary(Strings.textCorreoElectronico),
                              icon: const Icon(Icons.mail),
                              keyboardType: TextInputType.emailAddress,
                              controller: correoController,
                              validator: (valor) {
                                if (valor!.isEmpty) {
                                  return localizations
                                      .dictionary(Strings.textCorreoVacio);
                                }
                                return null;
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                            ),
                            InputText(
                                obscureText: true,
                                icon: const Icon(Icons.password),
                                labelText: localizations
                                    .dictionary(Strings.textContrasena),
                                controller: contrasenaController,
                                validator: (valor) {
                                  if (valor!.isEmpty) {
                                    return localizations
                                        .dictionary(Strings.textCampoVacio);
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.visiblePassword),
                            ButtonPersonal(
                                color: const Color.fromARGB(181, 96, 185, 136),
                                color2: const Color(0xFF1cbb78),
                                ancho: 100,
                                alto: 40,
                                texto: localizations
                                    .dictionary(Strings.textIngresar),
                                onPressed: () async {
                                  //globalBloc!.add(LogueadoEvent());
                                  if (_keyForm.currentState!.validate()) {
                                    UsuarioModel? usuario = await authService
                                        .signInWithEmailAndPassword(
                                            correoController.text,
                                            contrasenaController.text);
                                    if (usuario == null) {
                                      // ignore: use_build_context_synchronously
                                      mostrarDialogoCredencialesInvalidas(
                                          context);
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      bool guardar = await Fingerprint
                                          .consultarGuardarCredenciales(
                                              context);
                                      if (guardar) {
                                        Fingerprint.guardarEnSharedPreferences(
                                            correoController.text,
                                            contrasenaController.text);
                                      }
                                    }
                                  }
                                }),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(localizations
                                      .dictionary(Strings.textNoTienesCuenta)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()),
                                        );
                                      },
                                      child: Text(localizations
                                          .dictionary(Strings.textRegistrate)))
                                ]),
                            const Divider(color: Colors.black54),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.google,
                                      size: 23,
                                    ),
                                    onPressed: () async {
                                      await authService.signOut();
                                      await authService.googleLogin();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.facebook),
                                    onPressed: () async {
                                      await authService.signOut();
                                      await authService.signInWithFacebook();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.twitter),
                                    onPressed: () async {
                                      await authService.signOut();
                                      await authService.signInWithTwitter();
                                    },
                                  ),
                                ]),
                            const SizedBox(height: 20),
                            Center(
                              child: Column(children: [
                                IconButton(
                                    onPressed: () async {
                                      await Fingerprint
                                          .verificarDisponibilidadHuellas();
                                      await Fingerprint
                                          .asignarCredencialesDesdeSharedPreferences();
                                      if (Fingerprint.correoPrefs != null &&
                                          Fingerprint.correoPrefs != "null" &&
                                          Fingerprint.isBiometricAvailable &&
                                          Fingerprint.hayHuellaDisponible) {
                                        bool autenticado =
                                            // ignore: use_build_context_synchronously
                                            await fingerprintLogin(context);
                                        if (autenticado) {
                                          authService
                                              .signInWithEmailAndPassword(
                                                  Fingerprint.correoPrefs!,
                                                  Fingerprint.contrasenaPrefs!);
                                        }
                                      } else if (Fingerprint.correoPrefs ==
                                              null ||
                                          Fingerprint.correoPrefs == "null") {
                                        // ignore: use_build_context_synchronously
                                        mostrarFlushBar(
                                            context,
                                            localizations.dictionary(Strings
                                                .noHayCredencialesAlmacenadas),
                                            localizations.dictionary(Strings
                                                .ingresaUsuarioYContrasena));
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        mostrarFlushBar(
                                            context,
                                            localizations.dictionary(
                                                Strings.noTienesHuella),
                                            localizations.dictionary(
                                                Strings.configuraHuella));
                                      }
                                    },
                                    icon: const Icon(Icons.fingerprint)),
                                Text(
                                  localizations
                                      .dictionary(Strings.textAccesoBiometrico),
                                )
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mostrarDialogoCredencialesInvalidas(context) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content:
            Text(localizations.dictionary(Strings.textCredencialesInvalidas)),
      ),
    );
  }

  mostrarFlushBar(context, String tittle, String message) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));
    Flushbar(
      title: tittle,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 8, bottom: 55.0, left: 8, right: 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: isDark ? Colors.black54 : Colors.teal[500]!,
    ).show(context);
  }

  Future<bool> fingerprintLogin(context) async {
    LocalAuthentication localAuth = LocalAuthentication();
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    try {
      var androidStrings = AndroidAuthMessages(
          signInTitle: localizations.dictionary(Strings.textIngresar),
          biometricHint: localizations.dictionary(Strings.verifiqueHuella),
          cancelButton: localizations.dictionary(Strings.botonCancelar),
          biometricRequiredTitle: "",
          deviceCredentialsSetupDescription: "",
          //biometricNotRecognized: "No reconocida",
          //biometricSuccess: "Huella reconocida",
          deviceCredentialsRequiredTitle: "",
          goToSettingsButton: "",
          goToSettingsDescription: "");

      //     // goToSettingsButton: 'settings',
      //     // goToSettingsDescription:
      //     //     'Please set up your Touch ID.',
      //     // lockOut: 'Please reenable your Touch ID'
      //     );

      var didAuthenticate = await localAuth.authenticate(
          authMessages: [androidStrings],
          localizedReason:
              localizations.dictionary(Strings.lectorSolicitudIdentificarse),
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: false,
            stickyAuth: false,
          ));

      if (didAuthenticate) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      if (e.code.toString() == "LockedOut") {
        mostrarFlushBar(
            context,
            localizations
                .dictionary(Strings.flushbarBloqueoLectorTemporalTitulo),
            localizations
                .dictionary(Strings.flushbarBloqueoLectorTemporalMensaje));
      }
      if (e.code.toString() == "PermanentlyLockedOut") {
        mostrarFlushBar(
            context,
            localizations
                .dictionary(Strings.flushbarBloqueoLectorPermanenteTitulo),
            localizations
                .dictionary(Strings.flushbarBloqueoLectorPermanenteMensaje));
      }
      print("${e.message}");
      return false;
    }
  }
}
