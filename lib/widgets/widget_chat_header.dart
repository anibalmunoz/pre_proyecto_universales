import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/pages/create_group/users_added.dart';
import 'package:pre_proyecto_universales/pages/create_group/users_to_add.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';

class ChatHeader extends StatelessWidget {
  final CanalModel canal;

  const ChatHeader({
    Key? key,
    required this.canal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool esMiCanal = (canal.creador == Home.user!.uid);

    return Container(
      height: 70,
      padding: const EdgeInsets.all(16).copyWith(left: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackButton(color: Colors.teal),
          Expanded(
            child: Text(
              canal.name!,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              esMiCanal
                  ? buildIcon(
                      Icons.person_add,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsersToAdd(
                                    canal: canal,
                                  )),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(width: 12),
              buildIcon(
                Icons.more_vert,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsersAdded(
                              canal: canal,
                            )),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget buildIcon(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
          ),
          child: Icon(icon, size: 25, color: Colors.white),
        ),
      );
}
