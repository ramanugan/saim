class AsignacionTecnico {
  final int? idAsignacionTecnico;
  final int idAsignacion;
  final int idEmpleado;
  final String rol;
  final bool esPlaneado;
  final bool confirmado;
  final String horaInicioAsignada;
  final String horaFinAsignada;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  AsignacionTecnico({
    this.idAsignacionTecnico,
    required this.idAsignacion,
    required this.idEmpleado,
    required this.rol,
    this.esPlaneado = true,
    this.confirmado = false,
    required this.horaInicioAsignada,
    required this.horaFinAsignada,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory AsignacionTecnico.fromJson(Map<String, dynamic> json) {
    return AsignacionTecnico(
      idAsignacionTecnico: json['id_asignacion_tecnico'],
      idAsignacion: json['id_asignacion'],
      idEmpleado: json['id_empleado'],
      rol: json['rol'] ?? '',
      esPlaneado: json['es_planeado'] ?? true,
      confirmado: json['confirmado'] ?? false,
      horaInicioAsignada: json['hora_inicio_asignada'] ?? '',
      horaFinAsignada: json['hora_fin_asignada'] ?? '',
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_asignacion': idAsignacion,
      'id_empleado': idEmpleado,
      'rol': rol,
      'es_planeado': esPlaneado,
      'confirmado': confirmado,
      'hora_inicio_asignada': horaInicioAsignada,
      'hora_fin_asignada': horaFinAsignada,
      'activo': activo,
    };
    if (idAsignacionTecnico != null && idAsignacionTecnico != 0) data['id_asignacion_tecnico'] = idAsignacionTecnico;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  AsignacionTecnico copyWith({
    int? idAsignacionTecnico,
    int? idAsignacion,
    int? idEmpleado,
    String? rol,
    bool? esPlaneado,
    bool? confirmado,
    String? horaInicioAsignada,
    String? horaFinAsignada,
    bool? activo,
  }) {
    return AsignacionTecnico(
      idAsignacionTecnico: idAsignacionTecnico ?? this.idAsignacionTecnico,
      idAsignacion: idAsignacion ?? this.idAsignacion,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      rol: rol ?? this.rol,
      esPlaneado: esPlaneado ?? this.esPlaneado,
      confirmado: confirmado ?? this.confirmado,
      horaInicioAsignada: horaInicioAsignada ?? this.horaInicioAsignada,
      horaFinAsignada: horaFinAsignada ?? this.horaFinAsignada,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
