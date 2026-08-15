class IgualaServicio {
  final int? idIgualaServicio;
  final int idIguala;
  final int idTipoServicio;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool esPrincipal;
  final String? alcanceParticular;
  final String estatus;
  final bool activo;

  IgualaServicio({
    this.idIgualaServicio,
    required this.idIguala,
    required this.idTipoServicio,
    required this.fechaInicio,
    this.fechaFin,
    required this.esPrincipal,
    this.alcanceParticular,
    required this.estatus,
    required this.activo,
  });

  factory IgualaServicio.fromJson(Map<String, dynamic> json) {
    return IgualaServicio(
      idIgualaServicio: json['id_iguala_servicio'] as int?,
      idIguala: json['id_iguala'] as int,
      idTipoServicio: json['id_tipo_servicio'] as int,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin'] as String) : null,
      esPrincipal: json['es_principal'] as bool,
      alcanceParticular: json['alcance_particular'] as String?,
      estatus: json['estatus'] as String,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idIgualaServicio != null) 'id_iguala_servicio': idIgualaServicio,
      'id_iguala': idIguala,
      'id_tipo_servicio': idTipoServicio,
      'fecha_inicio': fechaInicio.toIso8601String().split('T').first,
      'fecha_fin': fechaFin?.toIso8601String().split('T').first,
      'es_principal': esPrincipal,
      'alcance_particular': alcanceParticular,
      'estatus': estatus,
      'activo': activo,
    };
  }
}
