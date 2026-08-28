import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/tienda.dart';

final tiendasProvider = StateNotifierProvider<TiendasNotifier, AsyncValue<List<Tienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiendasNotifier(supabase);
});

/// Helper para dropdowns — lista de tiendas activas como Map
final helperTiendasProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(tiendasProvider);
  return state.when(
    data: (list) => AsyncValue.data(
      list.map((t) => {
        'id': t.idTienda,
        'nombre': '${t.determinante} - ${t.nombre}',
        'id_cliente': t.idCliente,
        'activo': t.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class TiendasNotifier extends SupabaseCrudNotifier<Tienda> {
  TiendasNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'tienda',
          primaryKey: 'id_tienda',
          fromJson: (json) => Tienda.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idTienda,
        );

  Future<void> fetchTiendas() => fetch();
  Future<void> addTienda(Tienda tienda) => add(tienda);
  Future<void> updateTienda(Tienda tienda) => updateItem(tienda);
  Future<void> deleteTienda(int idTienda) => deleteItem(idTienda);
}
