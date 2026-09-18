import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/asignacion_servicio.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'servicios_mantenimiento_provider.dart';
import 'cuadrillas_provider.dart';

final helperServiciosForAsignacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(serviciosMantenimientoProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperCuadrillasForAsignacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(cuadrillasProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final asignacionServiciosProvider = StateNotifierProvider<AsignacionServiciosNotifier, AsyncValue<List<AsignacionServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return AsignacionServiciosNotifier(supabase);
});

class AsignacionServiciosNotifier extends SupabaseCrudNotifier<AsignacionServicio> {
  AsignacionServiciosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'asignacion_servicio',
          primaryKey: 'id_asignacion',
          fromJson: (json) => AsignacionServicio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idAsignacion,
        );

  Future<void> fetchAsignacionServicios() => fetch();
  Future<void> addAsignacionServicio(AsignacionServicio item) => add(item);
  Future<void> updateAsignacionServicio(AsignacionServicio item) => updateItem(item);
  Future<void> deleteAsignacionServicio(int id) => deleteItem(id);
}
