class MotivoDesviacion {
  final int? idMotivoDesviacion;
  final String codigo;
  final String nombre;
  final String clasificacion;
  final bool requiereEvidencia;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  MotivoDesviacion({
    this.idMotivoDesviacion,
    required this.codigo,
    required this.nombre,
    required this.clasificacion,
    this.requiereEvidencia = false,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory MotivoDesviacion.fromJson(Map<String, dynamic> json) {
    return MotivoDesviacion(
      idMotivoDesviacion: json['id_motivo_desviacion'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      clasificacion: json['clasificacion'] ?? '',
      requiereEvidencia: json['requiere_evidencia'] ?? false,
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
      'clasificacion': clasificacion,
      'requiere_evidencia': requiereEvidencia,
      'activo': activo,
    };
    if (idMotivoDesviacion != null && idMotivoDesviacion != 0) data['id_motivo_desviacion'] = idMotivoDesviacion;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  MotivoDesviacion copyWith({
    int? idMotivoDesviacion,
    String? codigo,
    String? nombre,
    String? clasificacion,
    bool? requiereEvidencia,
    bool? activo,
  }) {
    return MotivoDesviacion(
      idMotivoDesviacion: idMotivoDesviacion ?? this.idMotivoDesviacion,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      clasificacion: clasificacion ?? this.clasificacion,
      requiereEvidencia: requiereEvidencia ?? this.requiereEvidencia,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
