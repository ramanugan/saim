import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/precio_refaccion.dart';

final helperRefaccionesForPrecioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperProveedoresForPrecioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final preciosRefaccionProvider = StateNotifierProvider<PreciosRefaccionNotifier, AsyncValue<List<PrecioRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return PreciosRefaccionNotifier(supabase);
});

class PreciosRefaccionNotifier extends StateNotifier<AsyncValue<List<PrecioRefaccion>>> {
  final dynamic _supabase;

  PreciosRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchPrecios();
  }

  Future<void> fetchPrecios() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('precio_refaccion')
          .select()
          .order('id_precio_refaccion', ascending: false);
      
      final List<PrecioRefaccion> list = (response as List)
          .map((json) => PrecioRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPrecio(PrecioRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('precio_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = PrecioRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePrecio(PrecioRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_precio_refaccion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('precio_refaccion')
          .update(data)
          .eq('id_precio_refaccion', item.idPrecioRefaccion as Object)
          .select()
          .single();

      final updatedItem = PrecioRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idPrecioRefaccion == updatedItem.idPrecioRefaccion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idPrecioRefaccion, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('precio_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_precio_refaccion', idPrecioRefaccion)
          .select()
          .single();

      final updatedItem = PrecioRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idPrecioRefaccion == updatedItem.idPrecioRefaccion ? updatedItem : x).toList(),
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
