import 'rol.dart';

class UsuarioRol {
  final int? idUsuarioRol;
  final int idRol;
  final Rol? rol;
  final bool activo;
  final int? ambitoCliente;
  final int? ambitoZona;

  UsuarioRol({
    this.idUsuarioRol,
    required this.idRol,
    this.rol,
    this.activo = true,
    this.ambitoCliente,
    this.ambitoZona,
  });

  factory UsuarioRol.fromJson(Map<String, dynamic> json) {
    return UsuarioRol(
      idUsuarioRol: json['id_usuario_rol'],
      idRol: json['id_rol'],
      rol: json['rol'] != null ? Rol.fromJson(json['rol']) : null,
      activo: json['activo'] ?? true,
      ambitoCliente: json['ambito_cliente'],
      ambitoZona: json['ambito_zona'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idUsuarioRol != null) 'id_usuario_rol': idUsuarioRol,
      'id_rol': idRol,
      'activo': activo,
      if (ambitoCliente != null) 'ambito_cliente': ambitoCliente,
      if (ambitoZona != null) 'ambito_zona': ambitoZona,
    };
  }
}

class Usuario {
  final int? idUsuario;
  final String? authId;
  final String correo;
  final String nombreUsuario;
  final String estadoCuenta;
  final bool requiereMfa;
  final int? idEmpleado;
  final List<UsuarioRol> roles;

  Usuario({
    this.idUsuario,
    this.authId,
    required this.correo,
    required this.nombreUsuario,
    this.estadoCuenta = 'ACTIVA',
    this.requiereMfa = false,
    this.idEmpleado,
    this.roles = const [],
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var rolesList = <UsuarioRol>[];
    if (json['usuario_rol'] != null && json['usuario_rol'] is List) {
      rolesList = (json['usuario_rol'] as List)
          .map((r) => UsuarioRol.fromJson(r))
          .toList();
    }

    return Usuario(
      idUsuario: json['id_usuario'],
      authId: json['auth_id'],
      correo: json['correo'],
      nombreUsuario: json['nombre_usuario'] ?? '',
      estadoCuenta: json['estado_cuenta'] ?? 'ACTIVA',
      requiereMfa: json['requiere_mfa'] ?? false,
      idEmpleado: json['id_empleado'],
      roles: rolesList,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'correo': correo,
      'nombre_usuario': nombreUsuario,
      'estado_cuenta': estadoCuenta,
      'requiere_mfa': requiereMfa,
    };
    if (idUsuario != null) data['id_usuario'] = idUsuario;
    if (authId != null) data['auth_id'] = authId;
    if (idEmpleado != null) data['id_empleado'] = idEmpleado;
    return data;
  }

  Usuario copyWith({
    int? idUsuario,
    String? authId,
    String? correo,
    String? nombreUsuario,
    String? estadoCuenta,
    bool? requiereMfa,
    int? idEmpleado,
    List<UsuarioRol>? roles,
  }) {
    return Usuario(
      idUsuario: idUsuario ?? this.idUsuario,
      authId: authId ?? this.authId,
      correo: correo ?? this.correo,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      estadoCuenta: estadoCuenta ?? this.estadoCuenta,
      requiereMfa: requiereMfa ?? this.requiereMfa,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      roles: roles ?? this.roles,
    );
  }
}
