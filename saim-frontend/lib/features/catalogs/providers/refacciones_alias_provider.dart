import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/refaccion_alias.dart';

final helperRefaccionesForAliasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperUsuariosForAliasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('usuario')
      .select('id_usuario, nombre_usuario')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final refaccionesAliasProvider = StateNotifierProvider<RefaccionesAliasNotifier, AsyncValue<List<RefaccionAlias>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesAliasNotifier(supabase);
});

class RefaccionesAliasNotifier extends StateNotifier<AsyncValue<List<RefaccionAlias>>> {
  final dynamic _supabase;

  RefaccionesAliasNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchAliases();
  }

  Future<void> fetchAliases() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('refaccion_alias')
          .select()
          .order('id_refaccion_alias', ascending: false);
      
      final List<RefaccionAlias> list = (response as List)
          .map((json) => RefaccionAlias.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addAlias(RefaccionAlias item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('refaccion_alias')
          .insert(data)
          .select()
          .single();

      final newItem = RefaccionAlias.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAlias(RefaccionAlias item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_refaccion_alias');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('refaccion_alias')
          .update(data)
          .eq('id_refaccion_alias', item.idRefaccionAlias as Object)
          .select()
          .single();

      final updatedItem = RefaccionAlias.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idRefaccionAlias == updatedItem.idRefaccionAlias ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idRefaccionAlias, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('refaccion_alias')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_refaccion_alias', idRefaccionAlias)
          .select()
          .single();

      final updatedItem = RefaccionAlias.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idRefaccionAlias == updatedItem.idRefaccionAlias ? updatedItem : x).toList(),
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
