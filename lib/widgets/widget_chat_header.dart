import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String name;

  const ChatHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 70,
        padding: const EdgeInsets.all(16).copyWith(left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackButton(color: Colors.teal),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     buildIcon(Icons.call),
            //     SizedBox(width: 12),
            //     buildIcon(Icons.videocam),
            //   ],
            // ),
            const SizedBox(width: 4),
          ],
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}
