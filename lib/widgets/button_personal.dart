import 'package:flutter/material.dart';

class ButtonPersonal extends StatefulWidget {
  double alto;
  double ancho;
  final String texto;
  final VoidCallback onPressed;
  Color color;
  Color color2;

  ButtonPersonal(
      {required this.texto,
      required this.onPressed,
      required this.alto,
      required this.color,
      required this.color2,
      required this.ancho});

  @override
  State createState() {
    return _ButtonPersonal();
  }
}

class _ButtonPersonal extends State<ButtonPersonal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
      height: widget.alto,
      width: widget.ancho,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                colors: [
                  widget.color, //  Color.fromARGB(181, 96, 185, 136), //arriba
                  widget.color2 //Color(0xFF1cbb78), //abajo
                ],
                begin: const FractionalOffset(0.2, 0.0),
                end: const FractionalOffset(1.0, 0.6),
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
      ),
    );
  }
}
