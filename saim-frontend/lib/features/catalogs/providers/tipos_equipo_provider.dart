import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/tipo_equipo.dart';

final tiposEquipoProvider = StateNotifierProvider<TiposEquipoNotifier, AsyncValue<List<TipoEquipo>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposEquipoNotifier(supabase);
});

/// Helper para dropdowns — lista de tipos de equipo activos como Map
final helperTiposEquipoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(tiposEquipoProvider);
  return state.when(
    data: (list) => AsyncValue.data(
      list.map((t) => {
        'id': t.idTipoEquipo,
        'nombre': '${t.codigo} - ${t.nombre}',
        'activo': t.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class TiposEquipoNotifier extends SupabaseCrudNotifier<TipoEquipo> {
  TiposEquipoNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'tipo_equipo',
          primaryKey: 'id_tipo_equipo',
          ascending: true,
          fromJson: (json) => TipoEquipo.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idTipoEquipo,
        );

  Future<void> fetchTiposEquipo() => fetch();
  Future<void> addTipoEquipo(TipoEquipo item) => add(item);
  Future<void> updateTipoEquipo(TipoEquipo item) => updateItem(item);
  Future<void> deleteTipoEquipo(int idTipoEquipo) => toggleStatus(idTipoEquipo, true);
}
