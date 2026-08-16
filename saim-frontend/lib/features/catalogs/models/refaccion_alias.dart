class RefaccionAlias {
  final int? idRefaccionAlias;
  final int idRefaccion;
  final int? validadoPor;
  final String alias;
  final String origen;
  final double? confianzaMatch;
  final bool activo;

  RefaccionAlias({
    this.idRefaccionAlias,
    required this.idRefaccion,
    this.validadoPor,
    required this.alias,
    required this.origen,
    this.confianzaMatch,
    required this.activo,
  });

  factory RefaccionAlias.fromJson(Map<String, dynamic> json) {
    return RefaccionAlias(
      idRefaccionAlias: json['id_refaccion_alias'] as int?,
      idRefaccion: json['id_refaccion'] as int,
      validadoPor: json['validado_por'] as int?,
      alias: json['alias'] as String,
      origen: json['origen'] as String,
      confianzaMatch: (json['confianza_match'] as num?)?.toDouble(),
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idRefaccionAlias != null) 'id_refaccion_alias': idRefaccionAlias,
      'id_refaccion': idRefaccion,
      'validado_por': validadoPor,
      'alias': alias,
      'origen': origen,
      'confianza_match': confianzaMatch,
      'activo': activo,
    };
  }
}
