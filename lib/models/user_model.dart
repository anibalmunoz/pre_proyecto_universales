import 'package:pre_proyecto_universales/models/channel_model.dart';

class UsuarioModel {
  final String? uid;
  final String? email;
  final String? name;
  final String? photoURL;
  Map<String, dynamic>? canales;

  UsuarioModel({this.uid, this.email, this.name, this.photoURL, this.canales});

  // UsuarioModel.fromJson(Map<String, dynamic> json)
  //     : uid = json['uid'] ?? "",
  //       name = json['change'],
  //       email = json['correo'],
  //       photoURL = json['nombre'],
  //       canales = json["canales"];
}
