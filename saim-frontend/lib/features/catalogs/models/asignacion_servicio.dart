class AsignacionServicio {
  final int? idAsignacion;
  final int idServicio;
  final int? idCuadrilla;
  final String fechaAsignacion;
  final String fechaInicioVigencia;
  final String? fechaFinVigencia;
  final String? motivoCambio;
  final String estado;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  AsignacionServicio({
    this.idAsignacion,
    required this.idServicio,
    this.idCuadrilla,
    required this.fechaAsignacion,
    required this.fechaInicioVigencia,
    this.fechaFinVigencia,
    this.motivoCambio,
    required this.estado,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory AsignacionServicio.fromJson(Map<String, dynamic> json) {
    return AsignacionServicio(
      idAsignacion: json['id_asignacion'],
      idServicio: json['id_servicio'],
      idCuadrilla: json['id_cuadrilla'],
      fechaAsignacion: json['fecha_asignacion'] ?? '',
      fechaInicioVigencia: json['fecha_inicio_vigencia'] ?? '',
      fechaFinVigencia: json['fecha_fin_vigencia'],
      motivoCambio: json['motivo_cambio'],
      estado: json['estado'] ?? 'VIGENTE',
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
      'fecha_asignacion': fechaAsignacion,
      'fecha_inicio_vigencia': fechaInicioVigencia,
      'fecha_fin_vigencia': fechaFinVigencia,
      'motivo_cambio': motivoCambio,
      'estado': estado,
      'activo': activo,
    };
    if (idAsignacion != null && idAsignacion != 0) data['id_asignacion'] = idAsignacion;
    if (idCuadrilla != null && idCuadrilla != 0) data['id_cuadrilla'] = idCuadrilla;
    if (idCuadrilla == 0) data['id_cuadrilla'] = null;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  AsignacionServicio copyWith({
    int? idAsignacion,
    int? idServicio,
    int? idCuadrilla,
    String? fechaAsignacion,
    String? fechaInicioVigencia,
    String? fechaFinVigencia,
    String? motivoCambio,
    String? estado,
    bool? activo,
  }) {
    return AsignacionServicio(
      idAsignacion: idAsignacion ?? this.idAsignacion,
      idServicio: idServicio ?? this.idServicio,
      idCuadrilla: idCuadrilla ?? this.idCuadrilla,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      fechaInicioVigencia: fechaInicioVigencia ?? this.fechaInicioVigencia,
      fechaFinVigencia: fechaFinVigencia ?? this.fechaFinVigencia,
      motivoCambio: motivoCambio ?? this.motivoCambio,
      estado: estado ?? this.estado,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
