class InventarioRefaccion {
  final int? idInventario;
  final int idAlmacen;
  final int idRefaccion;
  final double existencia;
  final double reservado;
  final double? disponible;
  final double stockMinimo;
  final double puntoReorden;
  final DateTime? fechaUltimoConteo;
  final DateTime? actualizadoEn;
  final bool activo;

  InventarioRefaccion({
    this.idInventario,
    required this.idAlmacen,
    required this.idRefaccion,
    this.existencia = 0.0,
    this.reservado = 0.0,
    this.disponible,
    this.stockMinimo = 0.0,
    this.puntoReorden = 0.0,
    this.fechaUltimoConteo,
    this.actualizadoEn,
    this.activo = true,
  });

  factory InventarioRefaccion.fromJson(Map<String, dynamic> json) {
    return InventarioRefaccion(
      idInventario: json['id_inventario'] as int?,
      idAlmacen: json['id_almacen'] as int,
      idRefaccion: json['id_refaccion'] as int,
      existencia: (json['existencia'] as num?)?.toDouble() ?? 0.0,
      reservado: (json['reservado'] as num?)?.toDouble() ?? 0.0,
      disponible: (json['disponible'] as num?)?.toDouble(),
      stockMinimo: (json['stock_minimo'] as num?)?.toDouble() ?? 0.0,
      puntoReorden: (json['punto_reorden'] as num?)?.toDouble() ?? 0.0,
      fechaUltimoConteo: json['fecha_ultimo_conteo'] != null ? DateTime.parse(json['fecha_ultimo_conteo'] as String) : null,
      actualizadoEn: json['actualizado_en'] != null ? DateTime.parse(json['actualizado_en'] as String) : null,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idInventario != null) 'id_inventario': idInventario,
      'id_almacen': idAlmacen,
      'id_refaccion': idRefaccion,
      'existencia': existencia,
      'reservado': reservado,
      // 'disponible' is GENERATED ALWAYS, do not include
      'stock_minimo': stockMinimo,
      'punto_reorden': puntoReorden,
      'fecha_ultimo_conteo': fechaUltimoConteo?.toIso8601String().split('T').first,
      'activo': activo,
    };
  }
}
