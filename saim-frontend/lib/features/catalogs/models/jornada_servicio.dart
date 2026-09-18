class JornadaServicio {
  final int? idJornada;
  final int idServicio;
  final int numeroJornada;
  final String fecha;
  final String? horaLlegada;
  final String horaInicioEfectivo;
  final String horaFinEfectivo;
  final String? horaSalida;
  final int minutosPausa;
  final String? observaciones;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  JornadaServicio({
    this.idJornada,
    required this.idServicio,
    required this.numeroJornada,
    required this.fecha,
    this.horaLlegada,
    required this.horaInicioEfectivo,
    required this.horaFinEfectivo,
    this.horaSalida,
    this.minutosPausa = 0,
    this.observaciones,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory JornadaServicio.fromJson(Map<String, dynamic> json) {
    return JornadaServicio(
      idJornada: json['id_jornada'],
      idServicio: json['id_servicio'],
      numeroJornada: json['numero_jornada'] ?? 1,
      fecha: json['fecha'] ?? '',
      horaLlegada: json['hora_llegada'],
      horaInicioEfectivo: json['hora_inicio_efectivo'] ?? '',
      horaFinEfectivo: json['hora_fin_efectivo'] ?? '',
      horaSalida: json['hora_salida'],
      minutosPausa: json['minutos_pausa'] ?? 0,
      observaciones: json['observaciones'],
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
      'numero_jornada': numeroJornada,
      'fecha': fecha,
      'hora_llegada': horaLlegada,
      'hora_inicio_efectivo': horaInicioEfectivo,
      'hora_fin_efectivo': horaFinEfectivo,
      'hora_salida': horaSalida,
      'minutos_pausa': minutosPausa,
      'observaciones': observaciones,
      'activo': activo,
    };
    if (idJornada != null && idJornada != 0) data['id_jornada'] = idJornada;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  JornadaServicio copyWith({
    int? idJornada,
    int? idServicio,
    int? numeroJornada,
    String? fecha,
    String? horaLlegada,
    String? horaInicioEfectivo,
    String? horaFinEfectivo,
    String? horaSalida,
    int? minutosPausa,
    String? observaciones,
    bool? activo,
  }) {
    return JornadaServicio(
      idJornada: idJornada ?? this.idJornada,
      idServicio: idServicio ?? this.idServicio,
      numeroJornada: numeroJornada ?? this.numeroJornada,
      fecha: fecha ?? this.fecha,
      horaLlegada: horaLlegada ?? this.horaLlegada,
      horaInicioEfectivo: horaInicioEfectivo ?? this.horaInicioEfectivo,
      horaFinEfectivo: horaFinEfectivo ?? this.horaFinEfectivo,
      horaSalida: horaSalida ?? this.horaSalida,
      minutosPausa: minutosPausa ?? this.minutosPausa,
      observaciones: observaciones ?? this.observaciones,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
