class Iguala {
  final int? idIguala;
  final int idZonaTienda;
  final String codigoIguala;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String estatus;
  final String? motivoBaja;
  final bool activo;

  Iguala({
    this.idIguala,
    required this.idZonaTienda,
    required this.codigoIguala,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estatus,
    this.motivoBaja,
    required this.activo,
  });

  factory Iguala.fromJson(Map<String, dynamic> json) {
    return Iguala(
      idIguala: json['id_iguala'] as int?,
      idZonaTienda: json['id_zona_tienda'] as int,
      codigoIguala: json['codigo_iguala'] as String,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      estatus: json['estatus'] as String,
      motivoBaja: json['motivo_baja'] as String?,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idIguala != null) 'id_iguala': idIguala,
      'id_zona_tienda': idZonaTienda,
      'codigo_iguala': codigoIguala,
      'fecha_inicio': fechaInicio.toIso8601String().split('T').first,
      'fecha_fin': fechaFin.toIso8601String().split('T').first,
      'estatus': estatus,
      'motivo_baja': motivoBaja,
      'activo': activo,
    };
  }
}
