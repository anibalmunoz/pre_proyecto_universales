import 'package:flutter/material.dart';

class ButtonPersonal extends StatefulWidget {
  double alto;
  double ancho;
  final String texto;
  final VoidCallback onPressed;

  ButtonPersonal(
      {required this.texto,
      required this.onPressed,
      required this.alto,
      required this.ancho});

  @override
  State createState() {
    return _ButtonPersonal();
  }
}

class _ButtonPersonal extends State<ButtonPersonal> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        height: widget.alto,
        width: widget.ancho,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: const LinearGradient(
              colors: [
                Color.fromARGB(181, 96, 185, 136), //arriba
                Color(0xFF1cbb78), //abajo
              ],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Text(
            widget.texto,
            style: const TextStyle(
                fontSize: 18.0, fontFamily: "Lato", color: Colors.white),
          ),
        ),
      ),
    );
  }
}
