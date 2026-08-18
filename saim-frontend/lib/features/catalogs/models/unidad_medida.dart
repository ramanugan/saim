class UnidadMedida {
  final int? idUnidadMedida;
  final String codigo;
  final String nombre;
  final String? simbolo;
  final bool activo;

  UnidadMedida({
    this.idUnidadMedida,
    required this.codigo,
    required this.nombre,
    this.simbolo,
    this.activo = true,
  });

  factory UnidadMedida.fromJson(Map<String, dynamic> json) {
    return UnidadMedida(
      idUnidadMedida: json['id_unidad_medida'] as int?,
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      simbolo: json['simbolo'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'codigo': codigo,
      'nombre': nombre,
      'simbolo': simbolo,
      'activo': activo,
    };
    if (idUnidadMedida != null) {
      data['id_unidad_medida'] = idUnidadMedida;
    }
    return data;
  }
}
