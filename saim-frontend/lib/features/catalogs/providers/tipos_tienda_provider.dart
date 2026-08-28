import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/tipo_tienda.dart';

final tiposTiendaProvider = StateNotifierProvider<TiposTiendaNotifier, AsyncValue<List<TipoTienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposTiendaNotifier(supabase);
});

final helperTiposTiendaProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final tiposState = ref.watch(tiposTiendaProvider);

  return tiposState.when(
    data: (list) => AsyncValue.data(
      list.map((t) => {
        'id': t.idTipoTienda,
        'nombre': t.nombre,
        'activo': t.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class TiposTiendaNotifier extends SupabaseCrudNotifier<TipoTienda> {
  TiposTiendaNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'tipo_tienda',
          primaryKey: 'id_tipo_tienda',
          ascending: true,
          orderBy: 'nombre',
          fromJson: (json) => TipoTienda.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idTipoTienda,
        );

  Future<void> fetchTiposTienda() => fetch();
  Future<void> addTipoTienda(TipoTienda item) => add(item);
  Future<void> updateTipoTienda(TipoTienda item) => updateItem(item);
}
