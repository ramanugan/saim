class SolicitudRefaccionDetalle {
  final int? idSolicitudRefaccionDetalle;
  final int idSolicitudRefaccion;
  final int? idRefaccion;
  final int? idEquipo;
  final String descripcionOriginal;
  final double cantidadNecesaria;
  final double cantidadSolicitada;
  final double cantidadAutorizada;
  final double cantidadPedida;
  final double cantidadSuministrada;
  final double cantidadInstalada;
  final double cantidadCancelada;
  final DateTime? fechaRequerida;
  final String? criticidad;
  final double? afectacionOperativaPct;
  final String estado;
  final bool activo;

  SolicitudRefaccionDetalle({
    this.idSolicitudRefaccionDetalle,
    required this.idSolicitudRefaccion,
    this.idRefaccion,
    this.idEquipo,
    required this.descripcionOriginal,
    required this.cantidadNecesaria,
    required this.cantidadSolicitada,
    this.cantidadAutorizada = 0.0,
    this.cantidadPedida = 0.0,
    this.cantidadSuministrada = 0.0,
    this.cantidadInstalada = 0.0,
    this.cantidadCancelada = 0.0,
    this.fechaRequerida,
    this.criticidad,
    this.afectacionOperativaPct,
    required this.estado,
    required this.activo,
  });

  factory SolicitudRefaccionDetalle.fromJson(Map<String, dynamic> json) {
    return SolicitudRefaccionDetalle(
      idSolicitudRefaccionDetalle: json['id_solicitud_refaccion_detalle'] as int?,
      idSolicitudRefaccion: json['id_solicitud_refaccion'] as int,
      idRefaccion: json['id_refaccion'] as int?,
      idEquipo: json['id_equipo'] as int?,
      descripcionOriginal: json['descripcion_original'] as String,
      cantidadNecesaria: (json['cantidad_necesaria'] as num).toDouble(),
      cantidadSolicitada: (json['cantidad_solicitada'] as num).toDouble(),
      cantidadAutorizada: (json['cantidad_autorizada'] as num? ?? 0.0).toDouble(),
      cantidadPedida: (json['cantidad_pedida'] as num? ?? 0.0).toDouble(),
      cantidadSuministrada: (json['cantidad_suministrada'] as num? ?? 0.0).toDouble(),
      cantidadInstalada: (json['cantidad_instalada'] as num? ?? 0.0).toDouble(),
      cantidadCancelada: (json['cantidad_cancelada'] as num? ?? 0.0).toDouble(),
      fechaRequerida: json['fecha_requerida'] != null ? DateTime.parse(json['fecha_requerida'] as String) : null,
      criticidad: json['criticidad'] as String?,
      afectacionOperativaPct: json['afectacion_operativa_pct'] != null ? (json['afectacion_operativa_pct'] as num).toDouble() : null,
      estado: json['estado'] as String? ?? 'PENDIENTE',
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idSolicitudRefaccionDetalle != null) 'id_solicitud_refaccion_detalle': idSolicitudRefaccionDetalle,
      'id_solicitud_refaccion': idSolicitudRefaccion,
      'id_refaccion': idRefaccion,
      'id_equipo': idEquipo,
      'descripcion_original': descripcionOriginal,
      'cantidad_necesaria': cantidadNecesaria,
      'cantidad_solicitada': cantidadSolicitada,
      'cantidad_autorizada': cantidadAutorizada,
      'cantidad_pedida': cantidadPedida,
      'cantidad_suministrada': cantidadSuministrada,
      'cantidad_instalada': cantidadInstalada,
      'cantidad_cancelada': cantidadCancelada,
      'fecha_requerida': fechaRequerida?.toIso8601String().split('T').first,
      'criticidad': criticidad,
      'afectacion_operativa_pct': afectacionOperativaPct,
      'estado': estado,
      'activo': activo,
    };
  }
}
