class Cliente {
  final int? idCliente;
  final String codigo;
  final String razonSocial;
  final String nombreComercial;
  final String? rfc;
  final String? correoContacto;
  final String? telefonoContacto;
  final String estatus;
  final bool activo;

  Cliente({
    this.idCliente,
    required this.codigo,
    required this.razonSocial,
    required this.nombreComercial,
    this.rfc,
    this.correoContacto,
    this.telefonoContacto,
    required this.estatus,
    this.activo = true,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['id_cliente'],
      codigo: json['codigo'] ?? '',
      razonSocial: json['razon_social'] ?? '',
      nombreComercial: json['nombre_comercial'] ?? '',
      rfc: json['rfc'],
      correoContacto: json['correo_contacto'],
      telefonoContacto: json['telefono_contacto'],
      estatus: json['estatus'] ?? 'Activo',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'codigo': codigo,
      'razon_social': razonSocial,
      'nombre_comercial': nombreComercial,
      'estatus': estatus,
      'activo': activo,
    };
    if (idCliente != null) data['id_cliente'] = idCliente;
    if (rfc != null) data['rfc'] = rfc;
    if (correoContacto != null) data['correo_contacto'] = correoContacto;
    if (telefonoContacto != null) data['telefono_contacto'] = telefonoContacto;
    return data;
  }
}
