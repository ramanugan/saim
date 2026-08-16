class SuministroRefaccionDetalle {
  final int? idSuministroDetalle;
  final int idSuministro;
  final int idSolicitudRefaccionDetalle;
  final double cantidadEntregada;
  final double cantidadRechazada;
  final String? motivoRechazo;
  final bool activo;

  SuministroRefaccionDetalle({
    this.idSuministroDetalle,
    required this.idSuministro,
    required this.idSolicitudRefaccionDetalle,
    required this.cantidadEntregada,
    this.cantidadRechazada = 0.0,
    this.motivoRechazo,
    required this.activo,
  });

  factory SuministroRefaccionDetalle.fromJson(Map<String, dynamic> json) {
    return SuministroRefaccionDetalle(
      idSuministroDetalle: json['id_suministro_detalle'] as int?,
      idSuministro: json['id_suministro'] as int,
      idSolicitudRefaccionDetalle: json['id_solicitud_refaccion_detalle'] as int,
      cantidadEntregada: (json['cantidad_entregada'] as num).toDouble(),
      cantidadRechazada: (json['cantidad_rechazada'] as num? ?? 0.0).toDouble(),
      motivoRechazo: json['motivo_rechazo'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idSuministroDetalle != null) 'id_suministro_detalle': idSuministroDetalle,
      'id_suministro': idSuministro,
      'id_solicitud_refaccion_detalle': idSolicitudRefaccionDetalle,
      'cantidad_entregada': cantidadEntregada,
      'cantidad_rechazada': cantidadRechazada,
      'motivo_rechazo': motivoRechazo,
      'activo': activo,
    };
  }
}
