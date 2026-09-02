class ZonaContrato {
  final int? idZonaContrato;
  final int idContratoVersion;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final int? coordinadorResponsable;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;

  ZonaContrato({
    this.idZonaContrato,
    required this.idContratoVersion,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.coordinadorResponsable,
    required this.fechaInicio,
    this.fechaFin,
    this.activo = true,
  });

  factory ZonaContrato.fromJson(Map<String, dynamic> json) {
    return ZonaContrato(
      idZonaContrato: json['id_zona_contrato'],
      idContratoVersion: json['id_contrato_version'] ?? 1,
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      coordinadorResponsable: json['coordinador_responsable'],
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : DateTime.now(),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_contrato_version': idContratoVersion,
      'codigo': codigo,
      'nombre': nombre,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'activo': activo,
    };
    if (idZonaContrato != null) data['id_zona_contrato'] = idZonaContrato;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (coordinadorResponsable != null) {
      data['coordinador_responsable'] = coordinadorResponsable;
    }
    if (fechaFin != null) data['fecha_fin'] = fechaFin?.toIso8601String();
    return data;
  }
}
