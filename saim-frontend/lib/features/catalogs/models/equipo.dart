class Equipo {
  final int? idEquipo;
  final int idTienda;
  final int idTipoEquipo;
  final String? codigoActivoCliente;
  final String? marca;
  final String? modelo;
  final String? numeroSerie;
  final String? ubicacionInterna;
  final String? fechaInstalacion;
  final String estadoOperativo;
  final String criticidad;
  final bool activo;

  // Campos adicionales traídos por el JOIN del backend
  final String? nombreTienda;
  final String? nombreTipoEquipo;

  Equipo({
    this.idEquipo,
    required this.idTienda,
    required this.idTipoEquipo,
    this.codigoActivoCliente,
    this.marca,
    this.modelo,
    this.numeroSerie,
    this.ubicacionInterna,
    this.fechaInstalacion,
    required this.estadoOperativo,
    required this.criticidad,
    this.activo = true,
    this.nombreTienda,
    this.nombreTipoEquipo,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      idEquipo: json['id_equipo'],
      idTienda: json['id_tienda'] ?? 0,
      idTipoEquipo: json['id_tipo_equipo'] ?? 0,
      codigoActivoCliente: json['codigo_activo_cliente'],
      marca: json['marca'],
      modelo: json['modelo'],
      numeroSerie: json['numero_serie'],
      ubicacionInterna: json['ubicacion_interna'],
      fechaInstalacion: json['fecha_instalacion'],
      estadoOperativo: json['estado_operativo'] ?? 'OPERATIVO',
      criticidad: json['criticidad'] ?? 'MEDIA',
      activo: json['activo'] ?? true,
      nombreTienda: json['nombre_tienda'],
      nombreTipoEquipo: json['nombre_tipo_equipo'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_tienda': idTienda,
      'id_tipo_equipo': idTipoEquipo,
      'estado_operativo': estadoOperativo,
      'criticidad': criticidad,
      'activo': activo,
    };
    if (idEquipo != null) data['id_equipo'] = idEquipo;
    if (codigoActivoCliente != null) data['codigo_activo_cliente'] = codigoActivoCliente;
    if (marca != null) data['marca'] = marca;
    if (modelo != null) data['modelo'] = modelo;
    if (numeroSerie != null) data['numero_serie'] = numeroSerie;
    if (ubicacionInterna != null) data['ubicacion_interna'] = ubicacionInterna;
    if (fechaInstalacion != null) data['fecha_instalacion'] = fechaInstalacion;
    return data;
  }
}
