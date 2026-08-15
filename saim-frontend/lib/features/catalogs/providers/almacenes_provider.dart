import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/almacen.dart';

final almacenesProvider = StateNotifierProvider<AlmacenesNotifier, AsyncValue<List<Almacen>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return AlmacenesNotifier(supabase);
});

class AlmacenesNotifier extends StateNotifier<AsyncValue<List<Almacen>>> {
  final dynamic _supabase;

  AlmacenesNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchAlmacenes();
  }

  Future<void> fetchAlmacenes() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('almacen')
          .select()
          .order('id_almacen', ascending: false);
      
      final List<Almacen> list = (response as List)
          .map((json) => Almacen.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addAlmacen(Almacen almacen) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = almacen.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('almacen')
          .insert(data)
          .select()
          .single();

      final newItem = Almacen.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAlmacen(Almacen almacen) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = almacen.toJson();
      data.remove('id_almacen');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('almacen')
          .update(data)
          .eq('id_almacen', almacen.idAlmacen as Object)
          .select()
          .single();

      final updatedItem = Almacen.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idAlmacen == updatedItem.idAlmacen ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idAlmacen, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('almacen')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_almacen', idAlmacen)
          .select()
          .single();

      final updatedItem = Almacen.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idAlmacen == updatedItem.idAlmacen ? updatedItem : x).toList(),
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
