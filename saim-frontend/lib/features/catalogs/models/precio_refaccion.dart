class PrecioRefaccion {
  final int? idPrecioRefaccion;
  final int idRefaccion;
  final int? idProveedor;
  final String tipoPrecio;
  final double precio;
  final String moneda;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;

  PrecioRefaccion({
    this.idPrecioRefaccion,
    required this.idRefaccion,
    this.idProveedor,
    required this.tipoPrecio,
    required this.precio,
    this.moneda = 'MXN',
    required this.fechaInicio,
    this.fechaFin,
    required this.activo,
  });

  factory PrecioRefaccion.fromJson(Map<String, dynamic> json) {
    return PrecioRefaccion(
      idPrecioRefaccion: json['id_precio_refaccion'] as int?,
      idRefaccion: json['id_refaccion'] as int,
      idProveedor: json['id_proveedor'] as int?,
      tipoPrecio: json['tipo_precio'] as String,
      precio: (json['precio'] as num).toDouble(),
      moneda: json['moneda'] as String? ?? 'MXN',
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin'] as String) : null,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idPrecioRefaccion != null) 'id_precio_refaccion': idPrecioRefaccion,
      'id_refaccion': idRefaccion,
      'id_proveedor': idProveedor,
      'tipo_precio': tipoPrecio,
      'precio': precio,
      'moneda': moneda,
      'fecha_inicio': fechaInicio.toIso8601String().split('T').first,
      'fecha_fin': fechaFin?.toIso8601String().split('T').first,
      'activo': activo,
    };
  }
}
