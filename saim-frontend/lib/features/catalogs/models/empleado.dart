class Empleado {
  final int? idEmpleado;
  final String numeroEmpleado;
  final String nombre;
  final String apellidoPaterno;
  final String? apellidoMaterno;
  final String? telefono;
  final String? correo;
  final String puesto;
  final String tipoEmpleado;
  final String? fechaIngreso;
  final String estadoLaboral;
  final bool activo;
  final DateTime? creadoEn;
  final int? creadoPor;
  final DateTime? actualizadoEn;
  final int? actualizadoPor;

  Empleado({
    this.idEmpleado,
    required this.numeroEmpleado,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    this.telefono,
    this.correo,
    required this.puesto,
    required this.tipoEmpleado,
    this.fechaIngreso,
    required this.estadoLaboral,
    this.activo = true,
    this.creadoEn,
    this.creadoPor,
    this.actualizadoEn,
    this.actualizadoPor,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['id_empleado'],
      numeroEmpleado: json['numero_empleado'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellido_paterno'] ?? '',
      apellidoMaterno: json['apellido_materno'],
      telefono: json['telefono'],
      correo: json['correo'],
      puesto: json['puesto'] ?? '',
      tipoEmpleado: json['tipo_empleado'] ?? '',
      fechaIngreso: json['fecha_ingreso'],
      estadoLaboral: json['estado_laboral'] ?? '',
      activo: json['activo'] ?? true,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      creadoPor: json['creado_por'],
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en']) : null,
      actualizadoPor: json['actualizado_por'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'numero_empleado': numeroEmpleado,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'telefono': telefono,
      'correo': correo,
      'puesto': puesto,
      'tipo_empleado': tipoEmpleado,
      'fecha_ingreso': fechaIngreso,
      'estado_laboral': estadoLaboral,
      'activo': activo,
    };
    if (idEmpleado != null && idEmpleado != 0) data['id_empleado'] = idEmpleado;
    if (creadoPor != null) data['creado_por'] = creadoPor;
    if (actualizadoPor != null) data['actualizado_por'] = actualizadoPor;
    return data;
  }

  Empleado copyWith({
    int? idEmpleado,
    String? numeroEmpleado,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? telefono,
    String? correo,
    String? puesto,
    String? tipoEmpleado,
    String? fechaIngreso,
    String? estadoLaboral,
    bool? activo,
  }) {
    return Empleado(
      idEmpleado: idEmpleado ?? this.idEmpleado,
      numeroEmpleado: numeroEmpleado ?? this.numeroEmpleado,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      puesto: puesto ?? this.puesto,
      tipoEmpleado: tipoEmpleado ?? this.tipoEmpleado,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      estadoLaboral: estadoLaboral ?? this.estadoLaboral,
      activo: activo ?? this.activo,
      creadoEn: creadoEn,
      creadoPor: creadoPor,
      actualizadoEn: actualizadoEn,
      actualizadoPor: actualizadoPor,
    );
  }
}
