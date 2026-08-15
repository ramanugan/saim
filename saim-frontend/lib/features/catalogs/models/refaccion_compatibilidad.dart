class RefaccionCompatibilidad {
  final int? idCompatibilidad;
  final int idRefaccion;
  final int? idTipoEquipo;
  final String? marcaEquipo;
  final String? modeloEquipo;
  final String nivelCompatibilidad;
  final String? observacion;
  final bool activo;

  RefaccionCompatibilidad({
    this.idCompatibilidad,
    required this.idRefaccion,
    this.idTipoEquipo,
    this.marcaEquipo,
    this.modeloEquipo,
    required this.nivelCompatibilidad,
    this.observacion,
    required this.activo,
  });

  factory RefaccionCompatibilidad.fromJson(Map<String, dynamic> json) {
    return RefaccionCompatibilidad(
      idCompatibilidad: json['id_compatibilidad'] as int?,
      idRefaccion: json['id_refaccion'] as int,
      idTipoEquipo: json['id_tipo_equipo'] as int?,
      marcaEquipo: json['marca_equipo'] as String?,
      modeloEquipo: json['modelo_equipo'] as String?,
      nivelCompatibilidad: json['nivel_compatibilidad'] as String,
      observacion: json['observacion'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idCompatibilidad != null) 'id_compatibilidad': idCompatibilidad,
      'id_refaccion': idRefaccion,
      'id_tipo_equipo': idTipoEquipo,
      'marca_equipo': marcaEquipo,
      'modelo_equipo': modeloEquipo,
      'nivel_compatibilidad': nivelCompatibilidad,
      'observacion': observacion,
      'activo': activo,
    };
  }
}
