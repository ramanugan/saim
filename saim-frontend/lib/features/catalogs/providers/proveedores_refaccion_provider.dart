import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/proveedor_refaccion.dart';

final helperProveedoresForProvRefProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForProvRefProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final proveedoresRefaccionProvider = StateNotifierProvider<ProveedoresRefaccionNotifier, AsyncValue<List<ProveedorRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ProveedoresRefaccionNotifier(supabase);
});

class ProveedoresRefaccionNotifier extends StateNotifier<AsyncValue<List<ProveedorRefaccion>>> {
  final dynamic _supabase;

  ProveedoresRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchProveedoresRefaccion();
  }

  Future<void> fetchProveedoresRefaccion() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('proveedor_refaccion')
          .select()
          .order('id_proveedor_refaccion', ascending: false);
      
      final List<ProveedorRefaccion> list = (response as List)
          .map((json) => ProveedorRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addProveedorRefaccion(ProveedorRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('proveedor_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = ProveedorRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProveedorRefaccion(ProveedorRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_proveedor_refaccion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('proveedor_refaccion')
          .update(data)
          .eq('id_proveedor_refaccion', item.idProveedorRefaccion as Object)
          .select()
          .single();

      final updatedItem = ProveedorRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idProveedorRefaccion == updatedItem.idProveedorRefaccion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idProveedorRefaccion, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('proveedor_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_proveedor_refaccion', idProveedorRefaccion)
          .select()
          .single();

      final updatedItem = ProveedorRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idProveedorRefaccion == updatedItem.idProveedorRefaccion ? updatedItem : x).toList(),
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
