class TipoEquipo {
  final int? idTipoEquipo;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final bool activo;

  TipoEquipo({
    this.idTipoEquipo,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.activo = true,
  });

  factory TipoEquipo.fromJson(Map<String, dynamic> json) {
    return TipoEquipo(
      idTipoEquipo: json['id_tipo_equipo'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'codigo': codigo,
      'nombre': nombre,
      'activo': activo,
    };
    if (idTipoEquipo != null) data['id_tipo_equipo'] = idTipoEquipo;
    if (descripcion != null) data['descripcion'] = descripcion;
    return data;
  }
}
