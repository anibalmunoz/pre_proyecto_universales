class UsuarioModel {
  String? uid;
  String? email;
  String? name;
  String? photoURL;
  Map<String, dynamic>? canales;

  UsuarioModel({this.uid, this.email, this.name, this.photoURL, this.canales});

  UsuarioModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? "",
        name = json['nombre'],
        email = json['correo'] ?? "",
        photoURL = json['urlImage'],
        canales = json["canales"];
}
