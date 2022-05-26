import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';

class UsersToAdd extends StatefulWidget {
  UsersToAdd({Key? key}) : super(key: key);

  @override
  State<UsersToAdd> createState() => _UsersToAddState();
}

class _UsersToAddState extends State<UsersToAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCustomAppbar(context, title: "Agregar personas"),
    );
  }
}
