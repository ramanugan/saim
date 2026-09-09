import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/movimiento_inventario.dart';
import 'refacciones_provider.dart';
import 'almacenes_provider.dart';

final helperAlmacenesForMovimientoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(almacenesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperRefaccionesForMovimientoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final movimientosInventarioProvider = StateNotifierProvider<MovimientosInventarioNotifier, AsyncValue<List<MovimientoInventario>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return MovimientosInventarioNotifier(supabase);
});

class MovimientosInventarioNotifier extends SupabaseCrudNotifier<MovimientoInventario> {
  MovimientosInventarioNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'movimiento_inventario',
          primaryKey: 'id_movimiento',
          ascending: false,
          fromJson: (json) => MovimientoInventario.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idMovimiento,
        );

  Future<void> fetchMovimientos() => fetch();

  @override
  Future<void> add(MovimientoInventario item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await getCurrentUserId();
      
      final data = item.toJson();
      data['registrado_por'] = idUsuario;

      final response = await supabase
          .from(tableName)
          .insert(data)
          .select()
          .single();

      final newItem = MovimientoInventario.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMovimiento(MovimientoInventario item) => add(item);

  @override
  Future<void> updateItem(MovimientoInventario item) async {
    throw UnimplementedError('Update is not supported for movimiento_inventario');
  }

  @override
  Future<void> toggleStatus(Object id, bool currentStatus) async {
    throw UnimplementedError('ToggleStatus is not supported for movimiento_inventario');
  }
}
