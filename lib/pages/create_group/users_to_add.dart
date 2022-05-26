import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_people.dart';

class UsersToAdd extends StatefulWidget {
  static List<UsuarioModel>? usuariosDeEsteCanal = [];
  CanalModel canal;

  UsersToAdd({Key? key, required this.canal}) : super(key: key);

  @override
  State<UsersToAdd> createState() => _UsersToAddState();
}

class _UsersToAddState extends State<UsersToAdd> {
  List<UsuarioModel> usuariosLista = [];
  Set<UsuarioModel> usuariosSet = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCustomAppbar(context, title: "Agregar personas"),
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
                          usuarioOcupado = llaveUsuario;
                        }
                      },
                    );

                    if (llave != usuarioOcupado) {
                      usuariosLista.add(
                        UsuarioModel(
                          uid: llave,
                          name: data["nombre"],
                          email: data["correo"],
                          photoURL: data["urlImage"],
                        ),
                      );
                    }
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
      //bottomSheet: Container(height: 100),
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
            agregado: false,
            canal: widget.canal,
            usuario: usuario,
            // onTap: () async {

            // },

            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ChatPage(
            //               usuario: Home.user!,
            //               canalModel: CanalModel(
            //                   key: canal.key,
            //                   creador: canal.creador,
            //                   descripcion: canal.descripcion,
            //                   fechaCreacion: canal.fechaCreacion,
            //                   name: canal.name,
            //                   mensajes: canal.mensajes),
            //             )),
            //   );
            //   ChatService.shared.getMiCanales(Home.user!.uid!);
            // },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
