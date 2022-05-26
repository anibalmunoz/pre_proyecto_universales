class CanalModel {
  String? key;
  String? name;
  DateTime? fechaCreacion;
  String? descripcion;
  String? creador;
  Map<String, dynamic>? mensajes;

  CanalModel(
      {this.key,
      this.name,
      this.fechaCreacion,
      this.descripcion,
      this.creador,
      this.mensajes});

  CanalModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] ?? "",
        name = json['change'],
        fechaCreacion = json['correo'],
        descripcion = json['estado'],
        creador = json['nombre'];

  // Map<String, dynamic> toJson() => {
  //   'change': change,
  //   'correo': correo,
  //   'estado':estado,
  //   'nombre':nombre,
  //   'urlImage':urlImage,
  //   'Canales':canales
  // };

}
