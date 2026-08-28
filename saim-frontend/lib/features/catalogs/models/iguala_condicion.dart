class IgualaCondicion {
  final int? idIgualaCondicion;
  final int idIguala;
  final int? idIgualaServicio;
  final DateTime fechaInicioVigencia;
  final DateTime? fechaFinVigencia;
  final String periodicidadPreventivo;
  final String periodicidadFacturacion;
  final double montoPeriodico;
  final String moneda;
  final int duracionEstandarMinutos;
  final int numeroJornadas;
  final double horasPorJornada;
  final int tecnicosMinimos;
  final int tecnicosObjetivo;
  final double toleranciaDesviacionPct;
  final bool incluyeDiagnosticoCorrectivo;
  final double? limiteCorrectivoIncluido;
  final String? alcanceParticular;
  final bool activo;

  IgualaCondicion({
    this.idIgualaCondicion,
    required this.idIguala,
    this.idIgualaServicio,
    required this.fechaInicioVigencia,
    this.fechaFinVigencia,
    required this.periodicidadPreventivo,
    required this.periodicidadFacturacion,
    required this.montoPeriodico,
    required this.moneda,
    required this.duracionEstandarMinutos,
    required this.numeroJornadas,
    required this.horasPorJornada,
    required this.tecnicosMinimos,
    required this.tecnicosObjetivo,
    required this.toleranciaDesviacionPct,
    required this.incluyeDiagnosticoCorrectivo,
    this.limiteCorrectivoIncluido,
    this.alcanceParticular,
    required this.activo,
  });

  factory IgualaCondicion.fromJson(Map<String, dynamic> json) {
    return IgualaCondicion(
      idIgualaCondicion: json['id_iguala_condicion'] != null
          ? (json['id_iguala_condicion'] as num).toInt()
          : null,
      idIguala: (json['id_iguala'] as num).toInt(),
      idIgualaServicio: json['id_iguala_servicio'] != null
          ? (json['id_iguala_servicio'] as num).toInt()
          : null,
      fechaInicioVigencia: DateTime.parse(json['fecha_inicio_vigencia'] as String),
      fechaFinVigencia: json['fecha_fin_vigencia'] != null
          ? DateTime.parse(json['fecha_fin_vigencia'] as String)
          : null,
      periodicidadPreventivo: json['periodicidad_preventivo'] as String,
      periodicidadFacturacion: json['periodicidad_facturacion'] as String,
      montoPeriodico: (json['monto_periodico'] as num).toDouble(),
      moneda: json['moneda'] as String,
      duracionEstandarMinutos: (json['duracion_estandar_minutos'] as num).toInt(),
      numeroJornadas: (json['numero_jornadas'] as num).toInt(),
      horasPorJornada: (json['horas_por_jornada'] as num).toDouble(),
      tecnicosMinimos: (json['tecnicos_minimos'] as num).toInt(),
      tecnicosObjetivo: (json['tecnicos_objetivo'] as num).toInt(),
      toleranciaDesviacionPct: (json['tolerancia_desviacion_pct'] as num).toDouble(),
      incluyeDiagnosticoCorrectivo: json['incluye_diagnostico_correctivo'] as bool,
      limiteCorrectivoIncluido: json['limite_correctivo_incluido'] != null
          ? (json['limite_correctivo_incluido'] as num).toDouble()
          : null,
      alcanceParticular: json['alcance_particular'] as String?,
      activo: json['activo'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idIgualaCondicion != null) 'id_iguala_condicion': idIgualaCondicion,
      'id_iguala': idIguala,
      'id_iguala_servicio': idIgualaServicio,
      'fecha_inicio_vigencia': fechaInicioVigencia.toIso8601String().split('T').first,
      'fecha_fin_vigencia': fechaFinVigencia?.toIso8601String().split('T').first,
      'periodicidad_preventivo': periodicidadPreventivo,
      'periodicidad_facturacion': periodicidadFacturacion,
      'monto_periodico': montoPeriodico,
      'moneda': moneda,
      'duracion_estandar_minutos': duracionEstandarMinutos,
      'numero_jornadas': numeroJornadas,
      'horas_por_jornada': horasPorJornada,
      'tecnicos_minimos': tecnicosMinimos,
      'tecnicos_objetivo': tecnicosObjetivo,
      'tolerancia_desviacion_pct': toleranciaDesviacionPct,
      'incluye_diagnostico_correctivo': incluyeDiagnosticoCorrectivo,
      'limite_correctivo_incluido': limiteCorrectivoIncluido,
      'alcance_particular': alcanceParticular,
      'activo': activo,
    };
  }
}
