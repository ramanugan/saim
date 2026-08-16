class InstalacionRefaccion {
  final int? idInstalacion;
  final int idSolicitudRefaccionDetalle;
  final int idOrdenServicio;
  final int idEquipo;
  final double cantidadInstalada;
  final DateTime fechaInstalacion;
  final String resultadoPrueba;
  final String? observacion;
  final bool activo;

  InstalacionRefaccion({
    this.idInstalacion,
    required this.idSolicitudRefaccionDetalle,
    required this.idOrdenServicio,
    required this.idEquipo,
    required this.cantidadInstalada,
    required this.fechaInstalacion,
    required this.resultadoPrueba,
    this.observacion,
    required this.activo,
  });

  factory InstalacionRefaccion.fromJson(Map<String, dynamic> json) {
    return InstalacionRefaccion(
      idInstalacion: json['id_instalacion'] as int?,
      idSolicitudRefaccionDetalle: json['id_solicitud_refaccion_detalle'] as int,
      idOrdenServicio: json['id_orden_servicio'] as int,
      idEquipo: json['id_equipo'] as int,
      cantidadInstalada: (json['cantidad_instalada'] as num).toDouble(),
      fechaInstalacion: DateTime.parse(json['fecha_instalacion'] as String),
      resultadoPrueba: json['resultado_prueba'] as String,
      observacion: json['observacion'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idInstalacion != null) 'id_instalacion': idInstalacion,
      'id_solicitud_refaccion_detalle': idSolicitudRefaccionDetalle,
      'id_orden_servicio': idOrdenServicio,
      'id_equipo': idEquipo,
      'cantidad_instalada': cantidadInstalada,
      'fecha_instalacion': fechaInstalacion.toIso8601String(),
      'resultado_prueba': resultadoPrueba,
      'observacion': observacion,
      'activo': activo,
    };
  }
}
