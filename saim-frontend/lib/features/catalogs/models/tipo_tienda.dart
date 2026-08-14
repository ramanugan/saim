class TipoTienda {
  final int? idTipoTienda;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final bool activo;

  TipoTienda({
    this.idTipoTienda,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.activo = true,
  });

  factory TipoTienda.fromJson(Map<String, dynamic> json) {
    return TipoTienda(
      idTipoTienda: json['id_tipo_tienda'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idTipoTienda != null) 'id_tipo_tienda': idTipoTienda,
      'codigo': codigo,
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      'activo': activo,
    };
  }
}
