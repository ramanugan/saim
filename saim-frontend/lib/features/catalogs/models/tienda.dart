class Tienda {
  final int? idTienda;
  final int idCliente;
  final int? idTipoTienda;
  final String codigo;
  final String nombre;
  final String? direccion;
  final int? idMunicipio;
  final String? codigoPostal;
  final String? correoContacto;
  final String? telefonoContacto;
  final String estatus;
  final bool activo;

  Tienda({
    this.idTienda,
    required this.idCliente,
    this.idTipoTienda,
    required this.codigo,
    required this.nombre,
    this.direccion,
    this.idMunicipio,
    this.codigoPostal,
    this.correoContacto,
    this.telefonoContacto,
    required this.estatus,
    this.activo = true,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      idTienda: json['id_tienda'],
      idCliente: json['id_cliente'] ?? 0,
      idTipoTienda: json['id_tipo_tienda'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'],
      idMunicipio: json['id_municipio'],
      codigoPostal: json['codigo_postal'],
      correoContacto: json['correo_contacto'],
      telefonoContacto: json['telefono_contacto'],
      estatus: json['estatus'] ?? 'Activo',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_cliente': idCliente,
      'codigo': codigo,
      'nombre': nombre,
      'estatus': estatus,
      'activo': activo,
    };
    if (idTienda != null) data['id_tienda'] = idTienda;
    if (idTipoTienda != null) data['id_tipo_tienda'] = idTipoTienda;
    if (direccion != null) data['direccion'] = direccion;
    if (idMunicipio != null) data['id_municipio'] = idMunicipio;
    if (codigoPostal != null) data['codigo_postal'] = codigoPostal;
    if (correoContacto != null) data['correo_contacto'] = correoContacto;
    if (telefonoContacto != null) data['telefono_contacto'] = telefonoContacto;
    return data;
  }
}
