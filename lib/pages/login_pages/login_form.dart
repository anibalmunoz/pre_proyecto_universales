import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';
import 'package:pre_proyecto_universales/widgets/button_personal.dart';
import 'package:pre_proyecto_universales/widgets/widget_logo.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static GlobalBloc? basicBloc;

  @override
  Widget build(BuildContext context) {
    basicBloc = BlocProvider.of<GlobalBloc>(context);

    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final estiloBoton = ElevatedButton.styleFrom(
      primary: isDark ? AppColor.shared.turquezaOscuro : Colors.teal[400],
      onPrimary: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              //key:_keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(height: MediaQuery.of(context).size.height * .25),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Bienvenido a nuestra app de Chat ¡Conectate con nosotros!',
                        textAlign: TextAlign.center,
                        style: AppStyle.shared.fonts.LoginIntroduction(context),
                      )),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          onTap: () async {},
                          //autofillHints: [AutofillHints.email],
                          //controller: correoController,
                          // validator: (valor) {
                          //   //client.correo = valor;
                          //   if (valor!.isEmpty) {
                          //     return localizations.dictionary(
                          //         Strings.correoVacio);
                          //   }
                          //   if (!valor.isValidEmail) {
                          //     return localizations.dictionary(
                          //         Strings.correoInvalido);
                          //   }

                          //   return null;
                          // },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              icon: const Icon(Icons.mail_outline),
                              labelText: 'Correo Electrónico',
                              helperText: "mail@mail.com",
                              border: const OutlineInputBorder(),
                              isDense: false,
                              contentPadding: const EdgeInsets.all(10)),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        ),
                        TextFormField(
                          //   controller: contrasenaController,
                          // validator: (valor) {
                          //   client.contrasena = valor;
                          //   if (valor!.isEmpty) {
                          //     return localizations
                          //         .dictionary(Strings.campoVacio);
                          //   }
                          //   if (!valor.isValidPassword) {
                          //     return localizations.dictionary(
                          //         Strings
                          //             .contrasenaInvalidaDebeTener);
                          //   }

                          //   return null;
                          // },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.password_outlined),
                            labelText: 'Contraseña',
                            helperText: "Aa@45678",
                            border: OutlineInputBorder(),
                            isDense: false,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: ButtonPersonal(
                              ancho: 100,
                              alto: 50,
                              texto: 'Ingresar',
                              onPressed: () {
                                basicBloc!.add(LogueadoEvent());
                              }),
                        ),
                        const SizedBox(height: 20),
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
                            Text('Acceso Biométrico')
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
    );
  }
}
