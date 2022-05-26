class MessageModel {
  String? key;
  String? idUser;
  String? tipo;
  DateTime? fechaEnvio;
  String? contenido;

  MessageModel(
      {this.key, this.idUser, this.contenido, this.fechaEnvio, this.tipo});

  MessageModel.fromJson(Map<String, dynamic> json)
      : idUser = json['key'] ?? "",
        tipo = json['change'],
        fechaEnvio = json['correo'],
        contenido = json['estado'];
}
