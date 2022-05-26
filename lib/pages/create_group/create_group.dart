import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/widgets/button_personal.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_input_text.dart';

class CreateGroup extends StatefulWidget {
  UsuarioModel usuario;
  CreateGroup({Key? key, required this.usuario}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _keyForm = GlobalKey<FormState>();

  var nombreController = TextEditingController();
  var descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return Scaffold(
      appBar: getCustomAppbar(context,
          title: localizations.dictionary(Strings.tittleCrearGrupo)),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        InputText(
                          labelText:
                              localizations.dictionary(Strings.textNombre),
                          icon: const Icon(FontAwesomeIcons.userGroup),
                          keyboardType: TextInputType.text,
                          controller: nombreController,
                          validator: (valor) {
                            if (valor!.isEmpty) {
                              return localizations
                                  .dictionary(Strings.textCampoVacio);
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InputText(
                          labelText:
                              localizations.dictionary(Strings.textDescripcion),
                          icon: const Icon(FontAwesomeIcons.elementor),
                          keyboardType: TextInputType.text,
                          controller: descripcionController,
                          validator: (valor) {
                            if (valor!.isEmpty) {
                              return localizations
                                  .dictionary(Strings.textCampoVacio);
                            }

                            return null;
                          },
                        ),
                        ButtonPersonal(
                          texto: localizations.dictionary(Strings.save),
                          alto: 50,
                          color: const Color.fromARGB(181, 96, 185, 136),
                          color2: const Color(0xFF1cbb78),
                          ancho: 100,
                          onPressed: () async {
                            if (_keyForm.currentState!.validate()) {
                              await ChatService.shared.crearNuevoGrupo(
                                  nombreController.text,
                                  descripcionController.text,
                                  widget.usuario);
                              Navigator.pop(context);
                            }
                          },
                        ),
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
}
