class Municipio {
  final int? idMunicipio;
  final int idEstado;
  final String? claveInegi;
  final String nombre;
  final bool activo;

  Municipio({
    this.idMunicipio,
    required this.idEstado,
    this.claveInegi,
    required this.nombre,
    this.activo = true,
  });

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(
      idMunicipio: json['id_municipio'],
      idEstado: json['id_estado'],
      claveInegi: json['clave_inegi'],
      nombre: json['nombre'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idMunicipio != null) 'id_municipio': idMunicipio,
      'id_estado': idEstado,
      if (claveInegi != null) 'clave_inegi': claveInegi,
      'nombre': nombre,
      'activo': activo,
    };
  }
}
