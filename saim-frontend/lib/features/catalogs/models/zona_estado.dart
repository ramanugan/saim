class ZonaEstado {
  final int? idZonaEstado;
  final int idZonaContrato;
  final int idEstado;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool esExcepcion;
  final String? justificacion;
  final bool activo;

  ZonaEstado({
    this.idZonaEstado,
    required this.idZonaContrato,
    required this.idEstado,
    required this.fechaInicio,
    this.fechaFin,
    this.esExcepcion = false,
    this.justificacion,
    this.activo = true,
  });

  factory ZonaEstado.fromJson(Map<String, dynamic> json) {
    return ZonaEstado(
      idZonaEstado: json['id_zona_estado'],
      idZonaContrato: json['id_zona_contrato'] ?? 1,
      idEstado: json['id_estado'] ?? 1,
      fechaInicio: json['fecha_inicio'] != null 
          ? DateTime.parse(json['fecha_inicio']) 
          : DateTime.now(),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
      esExcepcion: json['es_excepcion'] ?? false,
      justificacion: json['justificacion'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_zona_contrato': idZonaContrato,
      'id_estado': idEstado,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'es_excepcion': esExcepcion,
      'activo': activo,
    };
    if (idZonaEstado != null) data['id_zona_estado'] = idZonaEstado;
    if (fechaFin != null) data['fecha_fin'] = fechaFin?.toIso8601String();
    if (justificacion != null) data['justificacion'] = justificacion;
    return data;
  }
}
