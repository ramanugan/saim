class ServicioMantenimiento {
  final int? idServicio;
  final int idIguala;
  final int idIgualaServicio;
  final String tipoMantenimiento;
  final String folioInterno;
  final String origen;
  final String prioridad;
  final String? fechaSolicitud;
  final String? fechaInicioReal;
  final String? fechaFinReal;
  final String estadoOperativo;
  final String estadoDocumental;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  ServicioMantenimiento({
    this.idServicio,
    required this.idIguala,
    required this.idIgualaServicio,
    required this.tipoMantenimiento,
    required this.folioInterno,
    required this.origen,
    required this.prioridad,
    this.fechaSolicitud,
    this.fechaInicioReal,
    this.fechaFinReal,
    required this.estadoOperativo,
    required this.estadoDocumental,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory ServicioMantenimiento.fromJson(Map<String, dynamic> json) {
    return ServicioMantenimiento(
      idServicio: json['id_servicio'],
      idIguala: json['id_iguala'],
      idIgualaServicio: json['id_iguala_servicio'],
      tipoMantenimiento: json['tipo_mantenimiento'] ?? '',
      folioInterno: json['folio_interno'] ?? '',
      origen: json['origen'] ?? '',
      prioridad: json['prioridad'] ?? '',
      fechaSolicitud: json['fecha_solicitud'],
      fechaInicioReal: json['fecha_inicio_real'],
      fechaFinReal: json['fecha_fin_real'],
      estadoOperativo: json['estado_operativo'] ?? '',
      estadoDocumental: json['estado_documental'] ?? '',
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_iguala': idIguala,
      'id_iguala_servicio': idIgualaServicio,
      'tipo_mantenimiento': tipoMantenimiento,
      'folio_interno': folioInterno,
      'origen': origen,
      'prioridad': prioridad,
      'fecha_solicitud': fechaSolicitud,
      'fecha_inicio_real': fechaInicioReal,
      'fecha_fin_real': fechaFinReal,
      'estado_operativo': estadoOperativo,
      'estado_documental': estadoDocumental,
      'activo': activo,
    };
    if (idServicio != null && idServicio != 0) data['id_servicio'] = idServicio;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  ServicioMantenimiento copyWith({
    int? idServicio,
    int? idIguala,
    int? idIgualaServicio,
    String? tipoMantenimiento,
    String? folioInterno,
    String? origen,
    String? prioridad,
    String? fechaSolicitud,
    String? fechaInicioReal,
    String? fechaFinReal,
    String? estadoOperativo,
    String? estadoDocumental,
    bool? activo,
  }) {
    return ServicioMantenimiento(
      idServicio: idServicio ?? this.idServicio,
      idIguala: idIguala ?? this.idIguala,
      idIgualaServicio: idIgualaServicio ?? this.idIgualaServicio,
      tipoMantenimiento: tipoMantenimiento ?? this.tipoMantenimiento,
      folioInterno: folioInterno ?? this.folioInterno,
      origen: origen ?? this.origen,
      prioridad: prioridad ?? this.prioridad,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      fechaInicioReal: fechaInicioReal ?? this.fechaInicioReal,
      fechaFinReal: fechaFinReal ?? this.fechaFinReal,
      estadoOperativo: estadoOperativo ?? this.estadoOperativo,
      estadoDocumental: estadoDocumental ?? this.estadoDocumental,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
