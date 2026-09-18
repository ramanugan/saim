import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/asignacion_tecnico.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'asignacion_servicios_provider.dart';
import 'empleados_provider.dart';

final helperAsignacionServiciosForTecnicoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(asignacionServiciosProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperEmpleadosForAsignacionTecnicoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(empleadosProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final asignacionTecnicosProvider = StateNotifierProvider<AsignacionTecnicosNotifier, AsyncValue<List<AsignacionTecnico>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return AsignacionTecnicosNotifier(supabase);
});

class AsignacionTecnicosNotifier extends SupabaseCrudNotifier<AsignacionTecnico> {
  AsignacionTecnicosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'asignacion_tecnico',
          primaryKey: 'id_asignacion_tecnico',
          fromJson: (json) => AsignacionTecnico.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idAsignacionTecnico,
        );

  Future<void> fetchAsignacionTecnicos() => fetch();
  Future<void> addAsignacionTecnico(AsignacionTecnico item) => add(item);
  Future<void> updateAsignacionTecnico(AsignacionTecnico item) => updateItem(item);
  Future<void> deleteAsignacionTecnico(int id) => deleteItem(id);
}
