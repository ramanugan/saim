class SuministroRefaccion {
  final int? idSuministro;
  final int idSolicitudRefaccion;
  final int? idProveedor;
  final int? idAlmacen;
  final String fuenteSuministro;
  final DateTime fechaSuministro;
  final String? documentoReferencia;
  final String? recibidoPor;
  final bool activo;

  SuministroRefaccion({
    this.idSuministro,
    required this.idSolicitudRefaccion,
    this.idProveedor,
    this.idAlmacen,
    required this.fuenteSuministro,
    required this.fechaSuministro,
    this.documentoReferencia,
    this.recibidoPor,
    required this.activo,
  });

  factory SuministroRefaccion.fromJson(Map<String, dynamic> json) {
    return SuministroRefaccion(
      idSuministro: json['id_suministro'] as int?,
      idSolicitudRefaccion: json['id_solicitud_refaccion'] as int,
      idProveedor: json['id_proveedor'] as int?,
      idAlmacen: json['id_almacen'] as int?,
      fuenteSuministro: json['fuente_suministro'] as String,
      fechaSuministro: DateTime.parse(json['fecha_suministro'] as String),
      documentoReferencia: json['documento_referencia'] as String?,
      recibidoPor: json['recibido_por'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idSuministro != null) 'id_suministro': idSuministro,
      'id_solicitud_refaccion': idSolicitudRefaccion,
      'id_proveedor': idProveedor,
      'id_almacen': idAlmacen,
      'fuente_suministro': fuenteSuministro,
      'fecha_suministro': fechaSuministro.toIso8601String(),
      'documento_referencia': documentoReferencia,
      'recibido_por': recibidoPor,
      'activo': activo,
    };
  }
}
