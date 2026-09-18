class JornadaTecnico {
  final int? idJornadaTecnico;
  final int idJornada;
  final int idEmpleado;
  final String horaInicio;
  final String horaFin;
  final int minutosEfectivos;
  final String participacion;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  JornadaTecnico({
    this.idJornadaTecnico,
    required this.idJornada,
    required this.idEmpleado,
    required this.horaInicio,
    required this.horaFin,
    required this.minutosEfectivos,
    required this.participacion,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory JornadaTecnico.fromJson(Map<String, dynamic> json) {
    return JornadaTecnico(
      idJornadaTecnico: json['id_jornada_tecnico'],
      idJornada: json['id_jornada'],
      idEmpleado: json['id_empleado'],
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      minutosEfectivos: json['minutos_efectivos'] ?? 0,
      participacion: json['participacion'] ?? '',
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_jornada': idJornada,
      'id_empleado': idEmpleado,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'minutos_efectivos': minutosEfectivos,
      'participacion': participacion,
      'activo': activo,
    };
    if (idJornadaTecnico != null && idJornadaTecnico != 0) data['id_jornada_tecnico'] = idJornadaTecnico;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  JornadaTecnico copyWith({
    int? idJornadaTecnico,
    int? idJornada,
    int? idEmpleado,
    String? horaInicio,
    String? horaFin,
    int? minutosEfectivos,
    String? participacion,
    bool? activo,
  }) {
    return JornadaTecnico(
      idJornadaTecnico: idJornadaTecnico ?? this.idJornadaTecnico,
      idJornada: idJornada ?? this.idJornada,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      minutosEfectivos: minutosEfectivos ?? this.minutosEfectivos,
      participacion: participacion ?? this.participacion,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
