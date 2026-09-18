class CuadrillaMiembro {
  final int? idCuadrillaMiembro;
  final int idCuadrilla;
  final int idEmpleado;
  final String rolCuadrilla;
  final String fechaInicio;
  final String? fechaFin;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  CuadrillaMiembro({
    this.idCuadrillaMiembro,
    required this.idCuadrilla,
    required this.idEmpleado,
    required this.rolCuadrilla,
    required this.fechaInicio,
    this.fechaFin,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory CuadrillaMiembro.fromJson(Map<String, dynamic> json) {
    return CuadrillaMiembro(
      idCuadrillaMiembro: json['id_cuadrilla_miembro'],
      idCuadrilla: json['id_cuadrilla'],
      idEmpleado: json['id_empleado'],
      rolCuadrilla: json['rol_cuadrilla'] ?? '',
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'],
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_cuadrilla': idCuadrilla,
      'id_empleado': idEmpleado,
      'rol_cuadrilla': rolCuadrilla,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'activo': activo,
    };
    if (idCuadrillaMiembro != null && idCuadrillaMiembro != 0) data['id_cuadrilla_miembro'] = idCuadrillaMiembro;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  CuadrillaMiembro copyWith({
    int? idCuadrillaMiembro,
    int? idCuadrilla,
    int? idEmpleado,
    String? rolCuadrilla,
    String? fechaInicio,
    String? fechaFin,
    bool? activo,
  }) {
    return CuadrillaMiembro(
      idCuadrillaMiembro: idCuadrillaMiembro ?? this.idCuadrillaMiembro,
      idCuadrilla: idCuadrilla ?? this.idCuadrilla,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      rolCuadrilla: rolCuadrilla ?? this.rolCuadrilla,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
