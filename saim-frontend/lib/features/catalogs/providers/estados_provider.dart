import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/estado.dart';
final estadosProvider = StateNotifierProvider<EstadosNotifier, AsyncValue<List<Estado>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EstadosNotifier(supabase);
});

final helperEstadosProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final estadosState = ref.watch(estadosProvider);

  return estadosState.when(
    data: (list) => AsyncValue.data(
      list.map((e) => {
        'id': e.idEstado,
        'nombre': e.nombre,
        'activo': e.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class EstadosNotifier extends SupabaseCrudNotifier<Estado> {
  EstadosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'estado',
          primaryKey: 'id_estado',
          ascending: true,
          fromJson: (json) => Estado.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idEstado,
        );

  Future<void> fetchEstados() => fetch();
  Future<void> addEstado(Estado item) => add(item);
  Future<void> updateEstado(Estado item) => updateItem(item);
}
