class OportunidadSuministro {
  final int? idOportunidad;
  final int idSolicitudRefaccionDetalle;
  final int? idCotizacion;
  final DateTime fechaDeteccion;
  final String motivo;
  final double cantidadOfertable;
  final double? montoEstimado;
  final String estado;
  final bool activo;

  OportunidadSuministro({
    this.idOportunidad,
    required this.idSolicitudRefaccionDetalle,
    this.idCotizacion,
    required this.fechaDeteccion,
    required this.motivo,
    required this.cantidadOfertable,
    this.montoEstimado,
    required this.estado,
    required this.activo,
  });

  factory OportunidadSuministro.fromJson(Map<String, dynamic> json) {
    return OportunidadSuministro(
      idOportunidad: json['id_oportunidad'] as int?,
      idSolicitudRefaccionDetalle: json['id_solicitud_refaccion_detalle'] as int,
      idCotizacion: json['id_cotizacion'] as int?,
      fechaDeteccion: DateTime.parse(json['fecha_deteccion'] as String),
      motivo: json['motivo'] as String,
      cantidadOfertable: (json['cantidad_ofertable'] as num).toDouble(),
      montoEstimado: json['monto_estimado'] != null ? (json['monto_estimado'] as num).toDouble() : null,
      estado: json['estado'] as String? ?? 'PENDIENTE',
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idOportunidad != null) 'id_oportunidad': idOportunidad,
      'id_solicitud_refaccion_detalle': idSolicitudRefaccionDetalle,
      'id_cotizacion': idCotizacion,
      'fecha_deteccion': fechaDeteccion.toIso8601String(),
      'motivo': motivo,
      'cantidad_ofertable': cantidadOfertable,
      'monto_estimado': montoEstimado,
      'estado': estado,
      'activo': activo,
    };
  }
}
