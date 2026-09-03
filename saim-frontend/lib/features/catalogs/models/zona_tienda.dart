class ZonaTienda {
  final int? idZonaTienda;
  final int idZona;
  final int idTienda;
  final DateTime fechaInicioCobertara;
  final DateTime? fechaFinCobertura;
  final String? numeroAnexo;
  final int? idDocumentoInclusion;
  final String estatus;
  final bool activo;

  ZonaTienda({
    this.idZonaTienda,
    required this.idZona,
    required this.idTienda,
    required this.fechaInicioCobertara,
    this.fechaFinCobertura,
    this.numeroAnexo,
    this.idDocumentoInclusion,
    required this.estatus,
    this.activo = true,
  });

  factory ZonaTienda.fromJson(Map<String, dynamic> json) {
    return ZonaTienda(
      idZonaTienda: json['id_zona_tienda'],
      idZona: json['id_zona'] ?? 0,
      idTienda: json['id_tienda'] ?? 0,
      fechaInicioCobertara: json['fecha_inicio_cobertura'] != null
          ? DateTime.parse(json['fecha_inicio_cobertura'])
          : DateTime.now(),
      fechaFinCobertura: json['fecha_fin_cobertura'] != null
          ? DateTime.parse(json['fecha_fin_cobertura'])
          : null,
      numeroAnexo: json['numero_anexo'],
      idDocumentoInclusion: json['id_documento_inclusion'],
      estatus: json['estatus'] ?? 'Activo',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_zona': idZona,
      'id_tienda': idTienda,
      'fecha_inicio_cobertura': fechaInicioCobertara.toIso8601String().split('T').first,
      'estatus': estatus,
      'activo': activo,
    };
    if (idZonaTienda != null) data['id_zona_tienda'] = idZonaTienda;
    if (fechaFinCobertura != null) data['fecha_fin_cobertura'] = fechaFinCobertura!.toIso8601String().split('T').first;
    if (numeroAnexo != null) data['numero_anexo'] = numeroAnexo;
    if (idDocumentoInclusion != null) data['id_documento_inclusion'] = idDocumentoInclusion;
    return data;
  }
}
