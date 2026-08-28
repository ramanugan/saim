class Proveedor {
  final int? idProveedor;
  final String razonSocial;
  final String? rfc;
  final String? contacto;
  final String? correo;
  final String? telefono;
  final String tipoProveedor;
  final int? creadoPor;
  final int? actualizadoPor;
  final bool activo;
  final String estatus;

  Proveedor({
    this.idProveedor,
    required this.razonSocial,
    this.rfc,
    this.contacto,
    this.correo,
    this.telefono,
    required this.tipoProveedor,
    this.creadoPor,
    this.actualizadoPor,
    this.activo = true,
    this.estatus = 'ACTIVO',
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: json['id_proveedor'] != null ? (json['id_proveedor'] as num).toInt() : null,
      razonSocial: json['razon_social'] ?? '',
      rfc: json['rfc'],
      contacto: json['contacto'],
      correo: json['correo'],
      telefono: json['telefono'],
      tipoProveedor: json['tipo_proveedor'] ?? '',
      creadoPor: json['creado_por'] != null ? (json['creado_por'] as num).toInt() : null,
      actualizadoPor: json['actualizado_por'] != null ? (json['actualizado_por'] as num).toInt() : null,
      activo: json['activo'] ?? true,
      estatus: json['estatus'] ?? 'ACTIVO',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'razon_social': razonSocial,
      'tipo_proveedor': tipoProveedor,
      'estatus': estatus,
      'activo': activo,
    };
    if (idProveedor != null) data['id_proveedor'] = idProveedor;
    if (rfc != null) data['rfc'] = rfc;
    if (contacto != null) data['contacto'] = contacto;
    if (correo != null) data['correo'] = correo;
    if (telefono != null) data['telefono'] = telefono;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }
}
