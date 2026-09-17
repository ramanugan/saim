class Especialidad {
  final int? idEspecialidad;
  final String codigo;
  final String nombre;
  final bool requiereCertificacion;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  Especialidad({
    this.idEspecialidad,
    required this.codigo,
    required this.nombre,
    required this.requiereCertificacion,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory Especialidad.fromJson(Map<String, dynamic> json) {
    return Especialidad(
      idEspecialidad: json['id_especialidad'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      requiereCertificacion: json['requiere_certificacion'] ?? false,
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
      'requiere_certificacion': requiereCertificacion,
      'activo': activo,
    };
    if (idEspecialidad != null && idEspecialidad != 0) data['id_especialidad'] = idEspecialidad;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  Especialidad copyWith({
    int? idEspecialidad,
    String? codigo,
    String? nombre,
    bool? requiereCertificacion,
    bool? activo,
  }) {
    return Especialidad(
      idEspecialidad: idEspecialidad ?? this.idEspecialidad,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      requiereCertificacion: requiereCertificacion ?? this.requiereCertificacion,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
