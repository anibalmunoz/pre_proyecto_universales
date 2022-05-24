class MessageModel {
  final String idUser;
  final String? contenido;
  final String? name;
  final String? photoURL;

  MessageModel(
      {required this.idUser, this.contenido, this.name, this.photoURL});
}
