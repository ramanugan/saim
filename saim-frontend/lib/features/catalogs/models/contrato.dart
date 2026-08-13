class Contrato {
  final int? idContrato;
  final int idCliente;
  final String numeroContrato;
  final String nombre;
  final String? fechaFirma;
  final String fechaInicio;
  final String fechaFin;
  final String moneda;
  final double? montoGlobal;
  final String periodicidadFacturacion;
  final String estatus;
  final bool activo;

  Contrato({
    this.idContrato,
    required this.idCliente,
    required this.numeroContrato,
    required this.nombre,
    this.fechaFirma,
    required this.fechaInicio,
    required this.fechaFin,
    required this.moneda,
    this.montoGlobal,
    required this.periodicidadFacturacion,
    required this.estatus,
    this.activo = true,
  });

  factory Contrato.fromJson(Map<String, dynamic> json) {
    return Contrato(
      idContrato: json['id_contrato'],
      idCliente: json['id_cliente'],
      numeroContrato: json['numero_contrato'] ?? '',
      nombre: json['nombre'] ?? '',
      fechaFirma: json['fecha_firma'],
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      moneda: json['moneda'] ?? 'MXN',
      montoGlobal: json['monto_global'] != null ? (json['monto_global'] as num).toDouble() : null,
      periodicidadFacturacion: json['periodicidad_facturacion'] ?? 'Mensual',
      estatus: json['estatus'] ?? 'Vigente',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id_cliente': idCliente,
      'numero_contrato': numeroContrato,
      'nombre': nombre,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'moneda': moneda,
      'periodicidad_facturacion': periodicidadFacturacion,
      'estatus': estatus,
      'activo': activo,
    };
    if (idContrato != null) data['id_contrato'] = idContrato;
    if (fechaFirma != null) data['fecha_firma'] = fechaFirma;
    if (montoGlobal != null) data['monto_global'] = montoGlobal;
    return data;
  }
}
