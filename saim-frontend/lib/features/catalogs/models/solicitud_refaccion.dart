class SolicitudRefaccion {
  final int? idSolicitudRefaccion;
  final int idIguala;
  final int? idOrdenServicio;
  final int solicitadoPor;
  final String folio;
  final DateTime fechaSolicitud;
  final String prioridad;
  final String estado;
  final bool activo;

  SolicitudRefaccion({
    this.idSolicitudRefaccion,
    required this.idIguala,
    this.idOrdenServicio,
    required this.solicitadoPor,
    required this.folio,
    required this.fechaSolicitud,
    required this.prioridad,
    required this.estado,
    required this.activo,
  });

  factory SolicitudRefaccion.fromJson(Map<String, dynamic> json) {
    return SolicitudRefaccion(
      idSolicitudRefaccion: json['id_solicitud_refaccion'] as int?,
      idIguala: json['id_iguala'] as int,
      idOrdenServicio: json['id_orden_servicio'] as int?,
      solicitadoPor: json['solicitado_por'] as int,
      folio: json['folio'] as String,
      fechaSolicitud: DateTime.parse(json['fecha_solicitud'] as String),
      prioridad: json['prioridad'] as String,
      estado: json['estado'] as String? ?? 'PENDIENTE',
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idSolicitudRefaccion != null) 'id_solicitud_refaccion': idSolicitudRefaccion,
      'id_iguala': idIguala,
      'id_orden_servicio': idOrdenServicio,
      'solicitado_por': solicitadoPor,
      'folio': folio,
      'fecha_solicitud': fechaSolicitud.toIso8601String(),
      'prioridad': prioridad,
      'estado': estado,
      'activo': activo,
    };
  }
}
