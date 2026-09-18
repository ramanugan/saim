class DesviacionServicio {
  final int? idDesviacion;
  final int idServicio;
  final int idMotivoDesviacion;
  final int minutosProgramados;
  final int minutosReales;
  final int desviacionMinutos;
  final double desviacionPorcentaje;
  final double horasHombreProgramadas;
  final double horasHombreReales;
  final String atribucionValidada;
  final String descripcion;
  final int? idSupervisorValida;
  final String? fechaValidacion;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  DesviacionServicio({
    this.idDesviacion,
    required this.idServicio,
    required this.idMotivoDesviacion,
    required this.minutosProgramados,
    required this.minutosReales,
    required this.desviacionMinutos,
    required this.desviacionPorcentaje,
    required this.horasHombreProgramadas,
    required this.horasHombreReales,
    required this.atribucionValidada,
    required this.descripcion,
    this.idSupervisorValida,
    this.fechaValidacion,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory DesviacionServicio.fromJson(Map<String, dynamic> json) {
    return DesviacionServicio(
      idDesviacion: json['id_desviacion'],
      idServicio: json['id_servicio'],
      idMotivoDesviacion: json['id_motivo_desviacion'],
      minutosProgramados: json['minutos_programados'] ?? 0,
      minutosReales: json['minutos_reales'] ?? 0,
      desviacionMinutos: json['desviacion_minutos'] ?? 0,
      desviacionPorcentaje: (json['desviacion_porcentaje'] ?? 0.0).toDouble(),
      horasHombreProgramadas: (json['horas_hombre_programadas'] ?? 0.0).toDouble(),
      horasHombreReales: (json['horas_hombre_reales'] ?? 0.0).toDouble(),
      atribucionValidada: json['atribucion_validada'] ?? '',
      descripcion: json['descripcion'] ?? '',
      idSupervisorValida: json['id_supervisor_valida'],
      fechaValidacion: json['fecha_validacion'],
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_servicio': idServicio,
      'id_motivo_desviacion': idMotivoDesviacion,
      'minutos_programados': minutosProgramados,
      'minutos_reales': minutosReales,
      'desviacion_minutos': desviacionMinutos,
      'desviacion_porcentaje': desviacionPorcentaje,
      'horas_hombre_programadas': horasHombreProgramadas,
      'horas_hombre_reales': horasHombreReales,
      'atribucion_validada': atribucionValidada,
      'descripcion': descripcion,
      'activo': activo,
    };
    if (idDesviacion != null && idDesviacion != 0) data['id_desviacion'] = idDesviacion;
    if (idSupervisorValida != null && idSupervisorValida != 0) data['id_supervisor_valida'] = idSupervisorValida;
    if (idSupervisorValida == 0) data['id_supervisor_valida'] = null;
    if (fechaValidacion != null && fechaValidacion!.isNotEmpty) data['fecha_validacion'] = fechaValidacion;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  DesviacionServicio copyWith({
    int? idDesviacion,
    int? idServicio,
    int? idMotivoDesviacion,
    int? minutosProgramados,
    int? minutosReales,
    int? desviacionMinutos,
    double? desviacionPorcentaje,
    double? horasHombreProgramadas,
    double? horasHombreReales,
    String? atribucionValidada,
    String? descripcion,
    int? idSupervisorValida,
    String? fechaValidacion,
    bool? activo,
  }) {
    return DesviacionServicio(
      idDesviacion: idDesviacion ?? this.idDesviacion,
      idServicio: idServicio ?? this.idServicio,
      idMotivoDesviacion: idMotivoDesviacion ?? this.idMotivoDesviacion,
      minutosProgramados: minutosProgramados ?? this.minutosProgramados,
      minutosReales: minutosReales ?? this.minutosReales,
      desviacionMinutos: desviacionMinutos ?? this.desviacionMinutos,
      desviacionPorcentaje: desviacionPorcentaje ?? this.desviacionPorcentaje,
      horasHombreProgramadas: horasHombreProgramadas ?? this.horasHombreProgramadas,
      horasHombreReales: horasHombreReales ?? this.horasHombreReales,
      atribucionValidada: atribucionValidada ?? this.atribucionValidada,
      descripcion: descripcion ?? this.descripcion,
      idSupervisorValida: idSupervisorValida ?? this.idSupervisorValida,
      fechaValidacion: fechaValidacion ?? this.fechaValidacion,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
