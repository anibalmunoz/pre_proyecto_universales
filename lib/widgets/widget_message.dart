import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/message_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:pre_proyecto_universales/widgets/widget_input_text.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final CanalModel canal;
  final UsuarioModel usuario;
  MessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.canal,
    required this.usuario,
  }) : super(key: key);

  //static String nombreUsuario = "";
  static String urlImage = "";

  late bool esOscuro;

  var mensajeControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    esOscuro = isDark;

    const radius = Radius.circular(12);
    final borderRaius = BorderRadius.all(radius);

    return FutureBuilder(
        future: ChatService.shared.buscarUsuario2(message.idUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            dynamic data = snapshot.requireData;
            String foto = data.photoURL;
            return Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: foto == ""
                          //EN EL SNAPSHOT DEBERÍA VENIR EL OBJETO USUARIO DEL CUAL PUEDA OBTENER LA IMAGEN
                          ? const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU')
                          : NetworkImage(foto),
                    ),
                  InkWell(
                    onLongPress: () async {
                      if (isMe) {
                        await consultaMensaje(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      margin: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: isMe
                            ? isDark
                                ? Colors.grey[350]
                                : Colors.grey[200]
                            : isDark
                                ? AppColor.shared.turquezaOscuro
                                : AppColor.shared.turquezaClaro,
                        borderRadius: isMe
                            ? borderRaius.subtract(
                                const BorderRadius.only(bottomRight: radius))
                            : borderRaius.subtract(
                                const BorderRadius.only(bottomLeft: radius)),
                      ),
                      child: buildMessage(context, snapshot.requireData),
                    ),
                  )
                ]);
          } else {
            return Container();
          }
        });
  }

  Widget buildMessage(context, data) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          //maxHeight: 30,
          minWidth: MediaQuery.of(context).size.width * 0.3,
          maxWidth: MediaQuery.of(context).size.width * 0.63),
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: !isMe
              ? [
                  Text(
                    data.name,
                    style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  Text(
                    message.contenido!,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                    textAlign: isMe ? TextAlign.start : TextAlign.start,
                  ),
                  Text(
                    DateFormat('hh:mm dd-MM-yyyy').format(message.fechaEnvio!),
                    style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontSize: 10),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  )
                ]
              : [
                  Text(
                    message.contenido!,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                    textAlign: isMe ? TextAlign.start : TextAlign.start,
                  ),
                  Text(
                    DateFormat('hh:mm dd-MM-yyyy').format(message.fechaEnvio!),
                    style: TextStyle(
                        color: isMe ? Colors.black : Colors.white,
                        fontSize: 10),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  )
                ],
        ),
      ),
    );
  }

  Future consultaMensaje(context) async {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Opciones"),
              content: Text("¿Que deseas hacer con este mensaje?"),
              actions: [
                TextButton(
                  child: const Text("Editar",
                      style: TextStyle(
                        color: Colors.blue,
                      )),
                  onPressed: () async {
                    Navigator.pop(context, false);

                    openDialog(context);
                  },
                ),
                TextButton(
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    await ChatService.shared
                        .eliminarMensaje(canal.key!, message.key!);
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ));
  }

  Future openDialog(context) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: "Edita tu mensaje",
        content: InputText(
          icon: Icon(Icons.message),
          labelText: "",
          validator: (valor) {},
          keyboardType: TextInputType.text,
          controller: mensajeControler,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              localizations.dictionary(Strings.botonCancelar),
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ChatService.shared.actualizarMensaje(mensajeControler.text,
                  usuario.uid!, canal.key!, message.key!, message.fechaEnvio!);
              Navigator.pop(context);
            },
            child: Text(localizations.dictionary(Strings.aceptar)),
          ),
        ],
      ),
    );
  }
}
