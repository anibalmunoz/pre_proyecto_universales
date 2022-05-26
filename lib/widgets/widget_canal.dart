import 'package:flutter/material.dart';

class Channel extends StatefulWidget {
  String titulo;
  VoidCallback? onTap;
  VoidCallback? onLongPress;
  String descripcion;
  Channel({
    Key? key,
    required this.titulo,
    this.onTap,
    required this.descripcion,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 75,
            decoration: const BoxDecoration(
              //color: Colors.amber,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2022/02/07/23/48/team-7000511_960_720.png'),
              ),
              title: Text(widget.titulo),
              subtitle: Text(widget.descripcion),
            ),
          ),
          const Divider(
            color: Colors.black54,
          )
        ],
      ),
    );
  }
}
