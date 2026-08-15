class MovimientoInventario {
  final int? idMovimiento;
  final int idAlmacen;
  final int idRefaccion;
  final String tipoMovimiento;
  final double cantidad;
  final DateTime? fechaHora;
  final String? referenciaEntidad;
  final int? registradoPor;

  MovimientoInventario({
    this.idMovimiento,
    required this.idAlmacen,
    required this.idRefaccion,
    required this.tipoMovimiento,
    required this.cantidad,
    this.fechaHora,
    this.referenciaEntidad,
    this.registradoPor,
  });

  factory MovimientoInventario.fromJson(Map<String, dynamic> json) {
    return MovimientoInventario(
      idMovimiento: json['id_movimiento'] as int?,
      idAlmacen: json['id_almacen'] as int,
      idRefaccion: json['id_refaccion'] as int,
      tipoMovimiento: json['tipo_movimiento'] as String,
      cantidad: (json['cantidad'] as num).toDouble(),
      fechaHora: json['fecha_hora'] != null ? DateTime.parse(json['fecha_hora'] as String) : null,
      referenciaEntidad: json['referencia_entidad'] as String?,
      registradoPor: json['registrado_por'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idMovimiento != null) 'id_movimiento': idMovimiento,
      'id_almacen': idAlmacen,
      'id_refaccion': idRefaccion,
      'tipo_movimiento': tipoMovimiento,
      'cantidad': cantidad,
      if (fechaHora != null) 'fecha_hora': fechaHora!.toIso8601String(),
      'referencia_entidad': referenciaEntidad,
      if (registradoPor != null) 'registrado_por': registradoPor,
    };
  }
}
