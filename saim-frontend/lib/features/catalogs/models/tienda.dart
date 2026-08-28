class Tienda {
  final int? idTienda;
  final int idCliente;
  final int idTipoTienda;
  final int idEstado;
  final int idMunicipio;
  final String determinante;
  final String nombre;
  final String? direccion;
  final String? codigoPostal;
  final String? telefono;
  final String estatus;
  final bool activo;

  Tienda({
    this.idTienda,
    required this.idCliente,
    required this.idTipoTienda,
    required this.idEstado,
    required this.idMunicipio,
    required this.determinante,
    required this.nombre,
    this.direccion,
    this.codigoPostal,
    this.telefono,
    required this.estatus,
    this.activo = true,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      idTienda: json['id_tienda'],
      idCliente: json['id_cliente'] ?? 0,
      idTipoTienda: json['id_tipo_tienda'] ?? 0,
      idEstado: json['id_estado'] ?? 0,
      idMunicipio: json['id_municipio'] ?? 0,
      determinante: json['determinante'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'],
      codigoPostal: json['codigo_postal'],
      telefono: json['telefono'],
      estatus: json['estatus'] ?? 'Activo',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_cliente': idCliente,
      'id_tipo_tienda': idTipoTienda,
      'id_estado': idEstado,
      'id_municipio': idMunicipio,
      'determinante': determinante,
      'nombre': nombre,
      'estatus': estatus,
      'activo': activo,
    };
    if (idTienda != null) data['id_tienda'] = idTienda;
    if (direccion != null) data['direccion'] = direccion;
    if (codigoPostal != null) data['codigo_postal'] = codigoPostal;
    if (telefono != null) data['telefono'] = telefono;
    return data;
  }
}
