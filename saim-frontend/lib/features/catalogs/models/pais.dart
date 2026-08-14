class Pais {
  final int? idPais;
  final String codigoIso;
  final String nombre;
  final bool activo;

  Pais({
    this.idPais,
    required this.codigoIso,
    required this.nombre,
    this.activo = true,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      idPais: json['id_pais'],
      codigoIso: json['codigo_iso']?.toString().trim() ?? '',
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo_iso': codigoIso,
      'nombre': nombre,
      'activo': activo,
    };
  }
}
