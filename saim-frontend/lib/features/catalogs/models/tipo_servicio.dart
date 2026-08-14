class TipoServicio {
  final int? idTipoServicio;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final bool activo;

  TipoServicio({
    this.idTipoServicio,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.activo = true,
  });

  factory TipoServicio.fromJson(Map<String, dynamic> json) {
    return TipoServicio(
      idTipoServicio: json['id_tipo_servicio'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idTipoServicio != null) 'id_tipo_servicio': idTipoServicio,
      'codigo': codigo,
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      'activo': activo,
    };
  }
}
