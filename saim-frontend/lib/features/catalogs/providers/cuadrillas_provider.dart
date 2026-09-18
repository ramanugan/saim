import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/cuadrilla.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'zonas_contrato_provider.dart';

final helperZonasContratoForCuadrillaProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(zonasContratoProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final cuadrillasProvider = StateNotifierProvider<CuadrillasNotifier, AsyncValue<List<Cuadrilla>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return CuadrillasNotifier(supabase);
});

class CuadrillasNotifier extends SupabaseCrudNotifier<Cuadrilla> {
  CuadrillasNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'cuadrilla',
          primaryKey: 'id_cuadrilla',
          fromJson: (json) => Cuadrilla.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idCuadrilla,
        );

  Future<void> fetchCuadrillas() => fetch();
  Future<void> addCuadrilla(Cuadrilla item) => add(item);
  Future<void> updateCuadrilla(Cuadrilla item) => updateItem(item);
  Future<void> deleteCuadrilla(int id) => deleteItem(id);
}
