import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.teal,
          child: Center(
              child: Image.asset(
            "assets/img/logo_chat.png",
            height: 500,
          )),
        ),
      ),
    );
  }
}
