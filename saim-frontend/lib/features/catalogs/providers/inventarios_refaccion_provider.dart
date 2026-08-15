import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/inventario_refaccion.dart';

final helperAlmacenesForInventarioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('almacen')
      .select('id_almacen, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForInventarioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final inventariosRefaccionProvider = StateNotifierProvider<InventariosRefaccionNotifier, AsyncValue<List<InventarioRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return InventariosRefaccionNotifier(supabase);
});

class InventariosRefaccionNotifier extends StateNotifier<AsyncValue<List<InventarioRefaccion>>> {
  final dynamic _supabase;

  InventariosRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchInventarios();
  }

  Future<void> fetchInventarios() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('inventario_refaccion')
          .select()
          .order('id_inventario', ascending: false);
      
      final List<InventarioRefaccion> list = (response as List)
          .map((json) => InventarioRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addInventario(InventarioRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('inventario_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = InventarioRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateInventario(InventarioRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_inventario');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('inventario_refaccion')
          .update(data)
          .eq('id_inventario', item.idInventario as Object)
          .select()
          .single();

      final updatedItem = InventarioRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idInventario == updatedItem.idInventario ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idInventario, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('inventario_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_inventario', idInventario)
          .select()
          .single();

      final updatedItem = InventarioRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idInventario == updatedItem.idInventario ? updatedItem : x).toList(),
      );
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
