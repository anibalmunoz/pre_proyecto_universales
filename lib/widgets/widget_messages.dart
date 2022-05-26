import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/message_model.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/widgets/widget_message.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;
  final String keyCanal;
  MessagesWidget({Key? key, required this.idUser, required this.keyCanal})
      : super(key: key);
  List<MessageModel> mensajesLista = [];

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    String myId = Home.user!.uid!;

    return StreamBuilder(
      stream: ChatService.shared.getMensajes(keyCanal).onValue,
      builder: ((context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:

          case ConnectionState.done:
            if (snapshot.hasData) {
              Map<dynamic, dynamic> mensajes = snapshot.data.snapshot.value;

              mensajesLista = [];

              mensajes.forEach((llave, valor) {
                Map<String, dynamic> data = json.decode(json.encode(valor));

                //Mensajemod canal = CanalModel.fromJson(data);

                //canal.key = llave;

                //for (var i in mensajesLista) {
                mensajesLista.add(
                  MessageModel(
                    idUser: data["usuario"],
                    contenido: data["texto"],
                    tipo: data["type"],
                    fechaEnvio: DateTime.fromMillisecondsSinceEpoch(
                        data['fecha_envio'] as int),
                  ),
                );
                //}

                //print(mensajes);
              });
            } else {
              // return mensajes == null
              return buildText("Di hola");
            }

            mensajesLista.sort((a, b) =>
                b.fechaEnvio.toString().compareTo(a.fechaEnvio.toString()));

            return getMessages();

          default:
            return Center(child: Container());
        }
      }),
    );
  }

  Widget getMessages() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      reverse: true,
      itemCount: mensajesLista.length,
      itemBuilder: (context, index) {
        final mensaje = mensajesLista[index];
        return MessageWidget(
          message: mensaje,
          isMe: mensaje.idUser == idUser,
        );
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      );
}
