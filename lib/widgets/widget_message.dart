import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/message_model.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/util/app_color.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  MessageWidget({Key? key, required this.message, required this.isMe})
      : super(key: key);

  static String nombreUsuario = "";

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    const radius = Radius.circular(12);
    final borderRaius = BorderRadius.all(radius);

    return FutureBuilder(
        future: ChatService.shared.buscarUsuario(message.idUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe)
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU'),
                    ),
                  InkWell(
                    onLongPress: () {
                      print("COMENZANDO ESTA AVENTURA");
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
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: !isMe
          ? [
              Text(
                data,
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                message.contenido!,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                DateFormat('hh:mm dd-MM-yyyy').format(message.fechaEnvio!),
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white, fontSize: 10),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              )
            ]
          : [
              Text(
                message.contenido!,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
              Text(
                DateFormat('hh:mm dd-MM-yyyy').format(message.fechaEnvio!),
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white, fontSize: 10),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              )
            ],
    );
  }
}
