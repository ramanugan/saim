import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/cuadrilla_miembro.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cuadrillas_provider.dart';
import 'empleados_provider.dart';

final helperCuadrillasForMiembroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(cuadrillasProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperEmpleadosForMiembroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(empleadosProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final cuadrillaMiembrosProvider = StateNotifierProvider<CuadrillaMiembrosNotifier, AsyncValue<List<CuadrillaMiembro>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return CuadrillaMiembrosNotifier(supabase);
});

class CuadrillaMiembrosNotifier extends SupabaseCrudNotifier<CuadrillaMiembro> {
  CuadrillaMiembrosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'cuadrilla_miembro',
          primaryKey: 'id_cuadrilla_miembro',
          fromJson: (json) => CuadrillaMiembro.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idCuadrillaMiembro,
        );

  Future<void> fetchCuadrillaMiembros() => fetch();
  Future<void> addCuadrillaMiembro(CuadrillaMiembro item) => add(item);
  Future<void> updateCuadrillaMiembro(CuadrillaMiembro item) => updateItem(item);
  Future<void> deleteCuadrillaMiembro(int id) => deleteItem(id);
}
