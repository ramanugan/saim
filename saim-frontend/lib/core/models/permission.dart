class Permission {
  final int? id;
  final String module;
  final String action;
  final String? description;

  Permission({
    this.id,
    required this.module,
    required this.action,
    this.description,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as int?,
      module: json['module'] as String,
      action: json['action'] as String,
      description: json['description'] as String?,
    );
  }

  // Comprueba si este permiso coincide con otro (útil para el guard)
  bool matches(String targetModule, String targetAction) {
    return module == targetModule && action == targetAction;
  }
}
