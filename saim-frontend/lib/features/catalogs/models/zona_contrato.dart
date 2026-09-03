class ZonaContrato {
  final int? idZonaContrato;
  final int idContratoVersion;
  final int? idZona;
  final String? numeroContrato;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final int? coordinadorResponsable;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;
  final bool versionActiva;

  ZonaContrato({
    this.idZonaContrato,
    required this.idContratoVersion,
    this.idZona,
    this.numeroContrato,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    this.coordinadorResponsable,
    required this.fechaInicio,
    this.fechaFin,
    this.activo = true,
    this.versionActiva = true,
  });

  factory ZonaContrato.fromJson(Map<String, dynamic> json) {
    return ZonaContrato(
      idZonaContrato: json['id_zona_contrato'],
      idContratoVersion: json['id_contrato_version'] ?? 1,
      idZona: json['id_zona'],
      numeroContrato: json['contrato_version']?['contrato']?['numero_contrato'],
      codigo: json['zona']?['codigo'] ?? json['codigo'] ?? '',
      nombre: json['zona']?['nombre'] ?? json['nombre'] ?? '',
      descripcion: json['zona']?['descripcion'] ?? json['descripcion'],
      coordinadorResponsable: json['coordinador_responsable'],
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : DateTime.now(),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
      activo: json['activo'] ?? true,
      versionActiva: json['contrato_version']?['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_contrato_version': idContratoVersion,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'activo': activo,
    };
    if (idZona != null) data['id_zona'] = idZona;
    if (idZonaContrato != null) data['id_zona_contrato'] = idZonaContrato;
    if (coordinadorResponsable != null) {
      data['coordinador_responsable'] = coordinadorResponsable;
    }
    if (fechaFin != null) data['fecha_fin'] = fechaFin?.toIso8601String();
    return data;
  }
}
