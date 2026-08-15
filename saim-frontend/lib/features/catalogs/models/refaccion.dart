class Refaccion {
  final int? idRefaccion;
  final int idCategoriaRefaccion;
  final String codigoInterno;
  final String descripcionHomologada;
  final String? marca;
  final String? numeroParte;
  final int idUnidadMedida;
  final String? criticidadDefault;
  final int? tiempoEntregaDias;
  final bool empresaPuedeSuministrar;
  final double stockMinimoDefault;
  final double puntoReordenDefault;
  final bool activo;

  Refaccion({
    this.idRefaccion,
    required this.idCategoriaRefaccion,
    required this.codigoInterno,
    required this.descripcionHomologada,
    this.marca,
    this.numeroParte,
    required this.idUnidadMedida,
    this.criticidadDefault,
    this.tiempoEntregaDias,
    this.empresaPuedeSuministrar = true,
    this.stockMinimoDefault = 0.0,
    this.puntoReordenDefault = 0.0,
    required this.activo,
  });

  factory Refaccion.fromJson(Map<String, dynamic> json) {
    return Refaccion(
      idRefaccion: json['id_refaccion'] as int?,
      idCategoriaRefaccion: json['id_categoria_refaccion'] as int,
      codigoInterno: json['codigo_interno'] as String,
      descripcionHomologada: json['descripcion_homologada'] as String,
      marca: json['marca'] as String?,
      numeroParte: json['numero_parte'] as String?,
      idUnidadMedida: json['id_unidad_medida'] as int,
      criticidadDefault: json['criticidad_default'] as String?,
      tiempoEntregaDias: json['tiempo_entrega_dias'] as int?,
      empresaPuedeSuministrar: json['empresa_puede_suministrar'] as bool? ?? true,
      stockMinimoDefault: (json['stock_minimo_default'] as num?)?.toDouble() ?? 0.0,
      puntoReordenDefault: (json['punto_reorden_default'] as num?)?.toDouble() ?? 0.0,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idRefaccion != null) 'id_refaccion': idRefaccion,
      'id_categoria_refaccion': idCategoriaRefaccion,
      'codigo_interno': codigoInterno,
      'descripcion_homologada': descripcionHomologada,
      'marca': marca,
      'numero_parte': numeroParte,
      'id_unidad_medida': idUnidadMedida,
      'criticidad_default': criticidadDefault,
      'tiempo_entrega_dias': tiempoEntregaDias,
      'empresa_puede_suministrar': empresaPuedeSuministrar,
      'stock_minimo_default': stockMinimoDefault,
      'punto_reorden_default': puntoReordenDefault,
      'activo': activo,
    };
  }
}
