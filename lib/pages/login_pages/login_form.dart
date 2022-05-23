import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/sign_up_page/sign_up.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';
import 'package:pre_proyecto_universales/widgets/button_personal.dart';
import 'package:pre_proyecto_universales/widgets/gradient_back.dart';
import 'package:pre_proyecto_universales/widgets/widget_input_text.dart';
import 'package:pre_proyecto_universales/widgets/widget_logo.dart';
import 'package:provider/provider.dart';

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
                                //client.correo = valor;
                                if (valor!.isEmpty) {
                                  return localizations
                                      .dictionary(Strings.textCorreoVacio);
                                }
                                // if (!valor.isValidEmail) {
                                //   return localizations
                                //       .dictionary(Strings.correoInvalido);
                                // }

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
                                  // client.contrasena = valor;
                                  if (valor!.isEmpty) {
                                    return localizations
                                        .dictionary(Strings.textCampoVacio);
                                  }
                                  // if (!valor.isValidPassword) {
                                  //   return localizations.dictionary(
                                  //       Strings
                                  //           .contrasenaInvalidaDebeTener);
                                  // }

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
                                    Usuario? usuario = await authService
                                        .signInWithEmailAndPassword(
                                            correoController.text,
                                            contrasenaController.text);
                                    if (usuario == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const AlertDialog(
                                          title: Text("Error"),
                                          content:
                                              Text('credenciales inválidas'),
                                        ),
                                      );
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
                                      authService.googleLogin();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.facebook),
                                    onPressed: () async {
                                      await authService.signOut();
                                      authService.signInWithFacebook();
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(FontAwesomeIcons.twitter),
                                    onPressed: () {},
                                  ),
                                ]),
                            const SizedBox(height: 20),
                            Center(
                              child: Column(children: [
                                IconButton(
                                    onPressed: () async {
                                      // await verificarDisponibilidadHuellas();

                                      // await asignarDesdeSharedPreferences();

                                      // if (correoPrefs !=
                                      //         null &&
                                      //     correoPrefs !=
                                      //         "null" &&
                                      //     isBiometricAvailable &&
                                      //     hayHuellaDisponible) {
                                      //   await mostrarSugerenciaLogin(
                                      //       context);
                                      // } else if (correoPrefs ==
                                      //         null ||
                                      //     correoPrefs ==
                                      //         "null") {
                                      //   mostrarFlushbarNoCredencialesGuardadas(
                                      //       context);
                                      // } else {
                                      //   mostrarFlushbarProblemasFingerprint(
                                      //       context);
                                      // }
                                      // // mostrarSugerenciaLogin(
                                      // //     context);
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
}
