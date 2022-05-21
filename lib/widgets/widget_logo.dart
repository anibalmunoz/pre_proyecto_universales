import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  double height;
  Logo({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(
      'assets/img/logo_chat.png',
      height: height,
    ));
  }
}
