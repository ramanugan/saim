class ProveedorRefaccion {
  final int? idProveedorRefaccion;
  final int idProveedor;
  final int idRefaccion;
  final String? codigoProveedor;
  final int? plazoEntregaDias;
  final bool esPreferente;
  final bool activo;

  ProveedorRefaccion({
    this.idProveedorRefaccion,
    required this.idProveedor,
    required this.idRefaccion,
    this.codigoProveedor,
    this.plazoEntregaDias,
    required this.esPreferente,
    required this.activo,
  });

  factory ProveedorRefaccion.fromJson(Map<String, dynamic> json) {
    return ProveedorRefaccion(
      idProveedorRefaccion: json['id_proveedor_refaccion'] as int?,
      idProveedor: json['id_proveedor'] as int,
      idRefaccion: json['id_refaccion'] as int,
      codigoProveedor: json['codigo_proveedor'] as String?,
      plazoEntregaDias: json['plazo_entrega_dias'] as int?,
      esPreferente: json['es_preferente'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idProveedorRefaccion != null) 'id_proveedor_refaccion': idProveedorRefaccion,
      'id_proveedor': idProveedor,
      'id_refaccion': idRefaccion,
      'codigo_proveedor': codigoProveedor,
      'plazo_entrega_dias': plazoEntregaDias,
      'es_preferente': esPreferente,
      'activo': activo,
    };
  }
}
