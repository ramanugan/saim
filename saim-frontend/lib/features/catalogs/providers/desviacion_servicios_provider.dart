import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/desviacion_servicio.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'servicios_mantenimiento_provider.dart';
import 'motivos_desviacion_provider.dart';
import 'empleados_provider.dart';

final helperServiciosForDesviacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(serviciosMantenimientoProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperEmpleadosForSupervisorProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(empleadosProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final desviacionServiciosProvider = StateNotifierProvider<DesviacionServiciosNotifier, AsyncValue<List<DesviacionServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return DesviacionServiciosNotifier(supabase);
});

class DesviacionServiciosNotifier extends SupabaseCrudNotifier<DesviacionServicio> {
  DesviacionServiciosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'desviacion_servicio',
          primaryKey: 'id_desviacion',
          fromJson: (json) => DesviacionServicio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idDesviacion,
        );

  Future<void> fetchDesviacionServicios() => fetch();
  Future<void> addDesviacionServicio(DesviacionServicio item) => add(item);
  Future<void> updateDesviacionServicio(DesviacionServicio item) => updateItem(item);
  Future<void> deleteDesviacionServicio(int id) => deleteItem(id);
}
