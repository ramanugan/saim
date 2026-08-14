class Estado {
  final int? idEstado;
  final int idPais;
  final String? claveInegi;
  final String nombre;
  final bool activo;

  Estado({
    this.idEstado,
    this.idPais = 1,
    this.claveInegi,
    required this.nombre,
    this.activo = true,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      idEstado: json['id_estado'],
      idPais: json['id_pais'] ?? 1,
      claveInegi: json['clave_inegi'],
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_pais': idPais,
      'nombre': nombre,
      'activo': activo,
    };
    if (idEstado != null) data['id_estado'] = idEstado;
    if (claveInegi != null) data['clave_inegi'] = claveInegi;
    return data;
  }
}
