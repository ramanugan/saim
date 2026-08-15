import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
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

class MovimientosInventarioNotifier extends StateNotifier<AsyncValue<List<MovimientoInventario>>> {
  final dynamic _supabase;

  MovimientosInventarioNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchMovimientos();
  }

  Future<void> fetchMovimientos() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('movimiento_inventario')
          .select()
          .order('id_movimiento', ascending: false);
      
      final List<MovimientoInventario> list = (response as List)
          .map((json) => MovimientoInventario.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addMovimiento(MovimientoInventario movimiento) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = movimiento.toJson();
      data['registrado_por'] = idUsuario;

      final response = await _supabase
          .from('movimiento_inventario')
          .insert(data)
          .select()
          .single();

      final newItem = MovimientoInventario.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> _getCurrentUserId() async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser != null) {
        final res = await _supabase.from('usuario').select('id_usuario').eq('correo', authUser.email as Object).maybeSingle();
        if (res != null) {
          return res['id_usuario'] as int;
        }
      }
    } catch (_) {}
    return 1;
  }
}
