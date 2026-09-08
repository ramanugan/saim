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

  Future<void> addTipoTienda(TipoTienda item) async {
    try {
      final currentList = state.value ?? [];
      final userIdInt = await getCurrentUserId();

      final data = item.toJson();
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;
      
      // We pass a dummy 'AUTO' value initially, it will be updated right after
      data['codigo'] = 'AUTO';
      
      final response = await supabase
          .from('tipo_tienda')
          .insert(data)
          .select()
          .single();
          
      final int id = response['id_tipo_tienda'];
      final codigoPad = id.toString().padLeft(3, '0');
      
      final updateResponse = await supabase
          .from('tipo_tienda')
          .update({'codigo': codigoPad})
          .eq('id_tipo_tienda', id)
          .select()
          .single();

      final newItem = TipoTienda.fromJson(updateResponse);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTipoTienda(TipoTienda item) => updateItem(item);
}
