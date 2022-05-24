import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const MessageWidget({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(12);
    final borderRaius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU'),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : Colors.teal,
            borderRadius: isMe
                ? borderRaius
                    .subtract(const BorderRadius.only(bottomRight: radius))
                : borderRaius
                    .subtract(const BorderRadius.only(bottomRight: radius)),
          ),
          child: buildMessage(),
        )
      ],
    );
  }

  Widget buildMessage() {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message.contenido!,
          style: TextStyle(color: isMe ? Colors.black : Colors.white),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        )
      ],
    );
  }
}
