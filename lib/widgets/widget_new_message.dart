import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';

import 'package:pre_proyecto_universales/util/app_color.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';

class NewMessage extends StatefulWidget {
  CanalModel canal;
  UsuarioModel usuario;
  NewMessage({Key? key, required this.canal, required this.usuario})
      : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String? message = "";

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? Colors.black : Colors.grey[100],
                labelText:
                    localizations.dictionary(Strings.escribeNuevoMensaje),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 10),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) => setState(() {
                message = value;
              }),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: message!.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColor.shared.turquezaOscuro
                      : AppColor.shared.turquezaClaro),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    //await FirebaseApi.uploadMessage(widget.idUser, message);

    await ChatService.shared
        .newMessage(widget.canal.key!, message!, widget.usuario.uid!, "text");
    _controller.clear();
  }
}
