import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/unidad_medida.dart';

final unidadesMedidaProvider = StateNotifierProvider<UnidadesMedidaNotifier, AsyncValue<List<UnidadMedida>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return UnidadesMedidaNotifier(supabase);
});

class UnidadesMedidaNotifier extends StateNotifier<AsyncValue<List<UnidadMedida>>> {
  final dynamic _supabase;

  UnidadesMedidaNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchUnidadesMedida();
  }

  Future<void> fetchUnidadesMedida() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('unidad_medida')
          .select()
          .order('id_unidad_medida', ascending: false);
      
      final List<UnidadMedida> list = (response as List)
          .map((json) => UnidadMedida.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addUnidadMedida(UnidadMedida item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('unidad_medida')
          .insert(data)
          .select()
          .single();

      final newItem = UnidadMedida.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUnidadMedida(UnidadMedida item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_unidad_medida');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('unidad_medida')
          .update(data)
          .eq('id_unidad_medida', item.idUnidadMedida as Object)
          .select()
          .single();

      final updatedItem = UnidadMedida.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idUnidadMedida == updatedItem.idUnidadMedida ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idUnidadMedida, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('unidad_medida')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_unidad_medida', idUnidadMedida)
          .select()
          .single();

      final updatedItem = UnidadMedida.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idUnidadMedida == updatedItem.idUnidadMedida ? updatedItem : x).toList(),
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
