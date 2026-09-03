class Empleado {
  final int idEmpleado;
  final String numeroEmpleado;
  final String nombre;
  final String apellidoPaterno;
  final String? apellidoMaterno;
  final String puesto;
  final String tipoEmpleado;
  final String estadoLaboral;
  final bool activo;

  Empleado({
    required this.idEmpleado,
    required this.numeroEmpleado,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    required this.puesto,
    required this.tipoEmpleado,
    required this.estadoLaboral,
    this.activo = true,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['id_empleado'],
      numeroEmpleado: json['numero_empleado'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellido_paterno'] ?? '',
      apellidoMaterno: json['apellido_materno'],
      puesto: json['puesto'] ?? '',
      tipoEmpleado: json['tipo_empleado'] ?? '',
      estadoLaboral: json['estado_laboral'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idEmpleado != 0) 'id_empleado': idEmpleado,
      'numero_empleado': numeroEmpleado,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'puesto': puesto,
      'tipo_empleado': tipoEmpleado,
      'estado_laboral': estadoLaboral,
      'activo': activo,
    };
  }
}
