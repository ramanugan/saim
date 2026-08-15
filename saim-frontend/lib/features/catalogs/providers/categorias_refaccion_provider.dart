import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/categoria_refaccion.dart';

final categoriasRefaccionProvider = StateNotifierProvider<CategoriasRefaccionNotifier, AsyncValue<List<CategoriaRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return CategoriasRefaccionNotifier(supabase);
});

class CategoriasRefaccionNotifier extends StateNotifier<AsyncValue<List<CategoriaRefaccion>>> {
  final dynamic _supabase;

  CategoriasRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('categoria_refaccion')
          .select()
          .order('id_categoria_refaccion', ascending: false);
      
      final List<CategoriaRefaccion> list = (response as List)
          .map((json) => CategoriaRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addCategoria(CategoriaRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('categoria_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = CategoriaRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategoria(CategoriaRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_categoria_refaccion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('categoria_refaccion')
          .update(data)
          .eq('id_categoria_refaccion', item.idCategoriaRefaccion as Object)
          .select()
          .single();

      final updatedItem = CategoriaRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idCategoriaRefaccion == updatedItem.idCategoriaRefaccion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idCategoria, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('categoria_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_categoria_refaccion', idCategoria)
          .select()
          .single();

      final updatedItem = CategoriaRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idCategoriaRefaccion == updatedItem.idCategoriaRefaccion ? updatedItem : x).toList(),
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
