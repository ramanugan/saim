import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/movimiento_inventario.dart';

final helperAlmacenesForMovimientoProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('almacen')
      .select('id_almacen, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForMovimientoProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
