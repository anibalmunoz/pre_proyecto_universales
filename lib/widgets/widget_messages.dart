import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/message_model.dart';
import 'package:pre_proyecto_universales/widgets/widget_message.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;
  const MessagesWidget({Key? key, required this.idUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    String myId = "";

    return StreamBuilder<List<MessageModel>>(
      builder: ((context, snapshot) {
        final mensajes = snapshot.data;
        return mensajes == null // isEmpty
            ? buildText("Di hola")
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final mensaje = mensajes[index];
                  return MessageWidget(
                    message: mensaje,
                    isMe: mensaje.idUser == myId,
                  );
                },
              );
      }),
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
