class Iguala {
  final int idIguala;
  final int idTienda;
  final int idTipoServicio;
  final String codigoIguala;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String estatus;
  final String? motivoBaja;
  final bool activo;

  Iguala({
    required this.idIguala,
    required this.idTienda,
    required this.idTipoServicio,
    required this.codigoIguala,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estatus,
    this.motivoBaja,
    required this.activo,
  });

  factory Iguala.fromJson(Map<String, dynamic> json) {
    return Iguala(
      idIguala: json['id_iguala'] as int,
      idTienda: json['id_tienda'] as int,
      idTipoServicio: json['id_tipo_servicio'] as int,
      codigoIguala: json['codigo_iguala'] as String,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      estatus: json['estatus'] as String,
      motivoBaja: json['motivo_baja'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idIguala != 0) 'id_iguala': idIguala,
      'id_tienda': idTienda,
      'id_tipo_servicio': idTipoServicio,
      'codigo_iguala': codigoIguala,
      'fecha_inicio': fechaInicio.toIso8601String().split('T')[0],
      'fecha_fin': fechaFin.toIso8601String().split('T')[0],
      'estatus': estatus,
      'motivo_baja': motivoBaja,
      'activo': activo,
    };
  }
}
