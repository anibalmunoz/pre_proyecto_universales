import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/widgets/widget_chat_header.dart';
import 'package:pre_proyecto_universales/widgets/widget_messages.dart';
import 'package:pre_proyecto_universales/widgets/widget_new_message.dart';

class ChatPage extends StatelessWidget {
  final CanalModel canalModel;
  final UsuarioModel usuario;
  const ChatPage({Key? key, required this.canalModel, required this.usuario})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Column(
        children: [
          ChatHeader(canal: canalModel),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.black38 : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: MessagesWidget(
                  canal: canalModel,
                  usuario: usuario,
                  idUser: usuario.uid!,
                  keyCanal: canalModel.key!),
            ),
          ),
          NewMessage(canal: canalModel, usuario: usuario),
        ],
      )),
    );
  }
}
