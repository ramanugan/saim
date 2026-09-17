class EmpleadoEspecialidad {
  final int? idEmpleadoEspecialidad;
  final int idEmpleado;
  final int idEspecialidad;
  final String nivel;
  final String? numeroCertificado;
  final String? vigenciaHasta;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  EmpleadoEspecialidad({
    this.idEmpleadoEspecialidad,
    required this.idEmpleado,
    required this.idEspecialidad,
    required this.nivel,
    this.numeroCertificado,
    this.vigenciaHasta,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory EmpleadoEspecialidad.fromJson(Map<String, dynamic> json) {
    return EmpleadoEspecialidad(
      idEmpleadoEspecialidad: json['id_empleado_especialidad'],
      idEmpleado: json['id_empleado'],
      idEspecialidad: json['id_especialidad'],
      nivel: json['nivel'] ?? '',
      numeroCertificado: json['numero_certificado'],
      vigenciaHasta: json['vigencia_hasta'],
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_empleado': idEmpleado,
      'id_especialidad': idEspecialidad,
      'nivel': nivel,
      'numero_certificado': numeroCertificado,
      'vigencia_hasta': vigenciaHasta,
      'activo': activo,
    };
    if (idEmpleadoEspecialidad != null && idEmpleadoEspecialidad != 0) data['id_empleado_especialidad'] = idEmpleadoEspecialidad;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  EmpleadoEspecialidad copyWith({
    int? idEmpleadoEspecialidad,
    int? idEmpleado,
    int? idEspecialidad,
    String? nivel,
    String? numeroCertificado,
    String? vigenciaHasta,
    bool? activo,
  }) {
    return EmpleadoEspecialidad(
      idEmpleadoEspecialidad: idEmpleadoEspecialidad ?? this.idEmpleadoEspecialidad,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      idEspecialidad: idEspecialidad ?? this.idEspecialidad,
      nivel: nivel ?? this.nivel,
      numeroCertificado: numeroCertificado ?? this.numeroCertificado,
      vigenciaHasta: vigenciaHasta ?? this.vigenciaHasta,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
