import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pre_proyecto_universales/bloc/global_bloc.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/widgets/button_personal.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_input_text.dart';
import 'package:provider/provider.dart';
import 'package:pre_proyecto_universales/util/extension.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _keyForm = GlobalKey<FormState>();
  static GlobalBloc? globalBloc;
  var correoController = TextEditingController();
  var contrasenaController = TextEditingController();
  var validarContrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    globalBloc = BlocProvider.of<GlobalBloc>(context);
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return Scaffold(
      appBar: getCustomAppbar(context,
          title: localizations.dictionary(Strings.textRegistrate)),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            if (!valor.isValidEmail) {
                              return localizations
                                  .dictionary(Strings.correoInvalido);
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
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
                              if (!valor.isValidPassword) {
                                return localizations.dictionary(
                                    Strings.contrasenaInvalidaDebeTener);
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        ),
                        InputText(
                            obscureText: true,
                            icon: const Icon(Icons.password),
                            labelText: localizations
                                .dictionary(Strings.textConfirmarContrasena),
                            controller: validarContrasenaController,
                            validator: (valor) {
                              if (valor!.isEmpty) {
                                return localizations
                                    .dictionary(Strings.textCampoVacio);
                              }
                              if (!valor.isValidPassword) {
                                return localizations.dictionary(
                                    Strings.contrasenaInvalidaDebeTener);
                              }
                              if (valor != contrasenaController.text) {
                                return localizations.dictionary(
                                    Strings.textContrasenaNoCoincide);
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword),
                        const SizedBox(height: 20),
                        ButtonPersonal(
                          texto:
                              localizations.dictionary(Strings.textRegistrate),
                          alto: 50,
                          color: const Color.fromARGB(181, 96, 185, 136),
                          color2: const Color(0xFF1cbb78),
                          ancho: 100,
                          onPressed: () async {
                            if (_keyForm.currentState!.validate()) {
                              await authService.createUserWithEmailAndPassword(
                                  context,
                                  correoController.text,
                                  contrasenaController.text);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  mostrarFlushbarCorreoYaUtilizado(
      context, String title, String message) async {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 8, bottom: 55.0, left: 8, right: 8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
