class CanalModel {
  String? key;
  String? name;
  String? fechaCreacion;
  String? descripcion;
  String? creador;

  CanalModel(
      {this.key,
      this.name,
      this.fechaCreacion,
      this.descripcion,
      this.creador});

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
