import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_people.dart';

class UsersAdded extends StatefulWidget {
  static List<UsuarioModel>? usuariosDeEsteCanal = [];
  CanalModel canal;

  UsersAdded({Key? key, required this.canal}) : super(key: key);

  @override
  State<UsersAdded> createState() => _UsersAddedState();
}

class _UsersAddedState extends State<UsersAdded> {
  List<UsuarioModel> usuariosLista = [];
  Set<UsuarioModel> usuariosSet = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCustomAppbar(context,
          title: "Miembros del canal",
          showButton: (widget.canal.creador == Home.user!.uid), onPressed: () {
        openDialogEliminar(context, widget.canal.key!, widget.canal.name!);
      }),
      body: StreamBuilder(
        stream: ChatService.shared.getUsuarios().onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:

            case ConnectionState.done:
              if (snapshot.hasData) {
                Map<dynamic, dynamic> usuarios = snapshot.data.snapshot.value;

                usuariosLista = [];

                String llaveUsuario = "";
                String usuarioOcupado = "";

                usuarios.forEach(
                  (llave, valor) {
                    Map<String, dynamic> data = json.decode(json.encode(valor));

                    Map<String, dynamic> canales = {};
                    if (data["canales"] == null) {
                      canales = data["Canales"] ?? {};
                    }

                    llaveUsuario = llave;

                    canales.forEach(
                      (llave, valor) {
                        if (llave == widget.canal.key) {
                          usuariosLista.add(
                            UsuarioModel(
                              uid: llaveUsuario,
                              name: data["nombre"],
                              email: data["correo"],
                              photoURL: data["urlImage"],
                            ),
                          );
                        }
                      },
                    );

                    if (llave != usuarioOcupado) {}
                  },
                );

                return buildUsers();
              }
              return const Center(child: CircularProgressIndicator());

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildUsers() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: usuariosLista.length,
      itemBuilder: (context, index) {
        final usuario = usuariosLista[index];

        if (usuariosLista.isNotEmpty) {
          return People(
            agregado: true,
            canal: widget.canal,
            usuario: usuario,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future openDialogEliminar(
    context,
    String canalKey,
    String canalNme,
  ) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar"),
        content: Text("¿Quieres Eliminar el canal $canalNme?"),
        actions: [
          TextButton(
            child: Text(
              localizations.dictionary(Strings.botonCancelar),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              localizations.dictionary(Strings.aceptar),
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              for (var item in usuariosLista) {
                print("El ID que tengo acá es: ");
                print(item.uid);

                await ChatService.shared.deleteChannelToUser(
                    widget.canal.key!, widget.canal.name!, item);
                await ChatService.shared
                    .eliminarCanal(widget.canal.key!, Home.user!.uid!);
              }

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
