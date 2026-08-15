class Almacen {
  final int? idAlmacen;
  final int? idEstado;
  final int? idMunicipio;
  final String codigo;
  final String nombre;
  final String? direccion;
  final bool activo;

  Almacen({
    this.idAlmacen,
    this.idEstado,
    this.idMunicipio,
    required this.codigo,
    required this.nombre,
    this.direccion,
    required this.activo,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      idAlmacen: json['id_almacen'] as int?,
      idEstado: json['id_estado'] as int?,
      idMunicipio: json['id_municipio'] as int?,
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idAlmacen != null) 'id_almacen': idAlmacen,
      'id_estado': idEstado,
      'id_municipio': idMunicipio,
      'codigo': codigo,
      'nombre': nombre,
      'direccion': direccion,
      'activo': activo,
    };
  }
}
