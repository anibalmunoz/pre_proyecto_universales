import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final estiloBoton = ElevatedButton.styleFrom(
      primary: MyApp.themeNotifier.value == ThemeMode.light
          ? Color.fromARGB(255, 41, 106, 202)
          : Colors.teal,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.login_sharp,
                    color: MyApp.themeNotifier.value == ThemeMode.light
                        ? Colors.blue
                        : Colors.blueAccent,
                    size: 150.0,
                  ),
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
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password_outlined),
                            // labelText: localizations.dictionary(
                            //     Strings.textFieldContrasena),
                            helperText: "Aa@45678",
                            border: const OutlineInputBorder(),
                            isDense: false,
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: estiloBoton,
                            onPressed: () async {
                              // if (_keyForm.currentState!
                              //     .validate()) {
                              //   bool logueado =
                              //       await login(context, false);
                              //   //agregarUbicacion();
                              //   if (logueado) {
                              //     agregarUbicacion();
                              //     basicBloc!.add(LogueadoEvent());
                              //   }
                              // }
                            },
                            child: Text('Ingresar'),
                          ),
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
