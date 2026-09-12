class OrganizacionProveedora {
  final int? idOrganizacion;
  final String razonSocial;
  final String? nombreComercial;
  final String rfc;
  final String? domicilioFiscal;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  OrganizacionProveedora({
    this.idOrganizacion,
    required this.razonSocial,
    this.nombreComercial,
    required this.rfc,
    this.domicilioFiscal,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory OrganizacionProveedora.fromJson(Map<String, dynamic> json) {
    return OrganizacionProveedora(
      idOrganizacion: json['id_organizacion'],
      razonSocial: json['razon_social'],
      nombreComercial: json['nombre_comercial'],
      rfc: json['rfc'],
      domicilioFiscal: json['domicilio_fiscal'],
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'razon_social': razonSocial,
      'nombre_comercial': nombreComercial,
      'rfc': rfc,
      'domicilio_fiscal': domicilioFiscal,
      'activo': activo,
    };
    if (idOrganizacion != null) data['id_organizacion'] = idOrganizacion;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  OrganizacionProveedora copyWith({
    int? idOrganizacion,
    String? razonSocial,
    String? nombreComercial,
    String? rfc,
    String? domicilioFiscal,
    bool? activo,
  }) {
    return OrganizacionProveedora(
      idOrganizacion: idOrganizacion ?? this.idOrganizacion,
      razonSocial: razonSocial ?? this.razonSocial,
      nombreComercial: nombreComercial ?? this.nombreComercial,
      rfc: rfc ?? this.rfc,
      domicilioFiscal: domicilioFiscal ?? this.domicilioFiscal,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
