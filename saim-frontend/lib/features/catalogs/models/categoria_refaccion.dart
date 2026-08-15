class CategoriaRefaccion {
  final int? idCategoriaRefaccion;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final bool activo;

  CategoriaRefaccion({
    this.idCategoriaRefaccion,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.activo,
  });

  factory CategoriaRefaccion.fromJson(Map<String, dynamic> json) {
    return CategoriaRefaccion(
      idCategoriaRefaccion: json['id_categoria_refaccion'] as int?,
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idCategoriaRefaccion != null) 'id_categoria_refaccion': idCategoriaRefaccion,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'activo': activo,
    };
  }
}
