class Cuadrilla {
  final int? idCuadrilla;
  final int? idZonaBase;
  final String codigo;
  final String nombre;
  final String estatus;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  Cuadrilla({
    this.idCuadrilla,
    this.idZonaBase,
    required this.codigo,
    required this.nombre,
    required this.estatus,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory Cuadrilla.fromJson(Map<String, dynamic> json) {
    return Cuadrilla(
      idCuadrilla: json['id_cuadrilla'],
      idZonaBase: json['id_zona_base'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      estatus: json['estatus'] ?? '',
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'codigo': codigo,
      'nombre': nombre,
      'estatus': estatus,
      'activo': activo,
    };
    if (idCuadrilla != null && idCuadrilla != 0) data['id_cuadrilla'] = idCuadrilla;
    if (idZonaBase != null && idZonaBase != 0) data['id_zona_base'] = idZonaBase;
    if (idZonaBase == 0) data['id_zona_base'] = null; // En caso de que se envíe 0 para desvincular
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  Cuadrilla copyWith({
    int? idCuadrilla,
    int? idZonaBase,
    String? codigo,
    String? nombre,
    String? estatus,
    bool? activo,
  }) {
    return Cuadrilla(
      idCuadrilla: idCuadrilla ?? this.idCuadrilla,
      idZonaBase: idZonaBase ?? this.idZonaBase,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      estatus: estatus ?? this.estatus,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
