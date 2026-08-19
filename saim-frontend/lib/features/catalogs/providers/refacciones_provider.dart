import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/refaccion.dart';
import 'categorias_refaccion_provider.dart';
import 'unidades_medida_provider.dart';

final helperCategoriasForRefaccionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final categoriasAsync = ref.watch(categoriasRefaccionProvider);
  return categoriasAsync.whenData((categorias) {
    return categorias
        .where((c) => c.activo)
        .map((c) => {
              'id_categoria_refaccion': c.idCategoriaRefaccion,
              'codigo': c.codigo,
              'nombre': c.nombre,
            })
        .toList();
  });
});

final helperUnidadesForRefaccionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final unidadesAsync = ref.watch(unidadesMedidaProvider);
  return unidadesAsync.whenData((unidades) {
    return unidades
        .where((u) => u.activo)
        .map((u) => {
              'id_unidad_medida': u.idUnidadMedida,
              'nombre': u.nombre,
              'simbolo': u.simbolo,
            })
        .toList();
  });
});

final refaccionesProvider = StateNotifierProvider<RefaccionesNotifier, AsyncValue<List<Refaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesNotifier(supabase);
});

class RefaccionesNotifier extends StateNotifier<AsyncValue<List<Refaccion>>> {
  final dynamic _supabase;

  RefaccionesNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchRefacciones();
  }

  Future<void> fetchRefacciones() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('refaccion')
          .select()
          .order('id_refaccion', ascending: false);
      
      final List<Refaccion> list = (response as List)
          .map((json) => Refaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addRefaccion(Refaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = Refaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRefaccion(Refaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_refaccion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('refaccion')
          .update(data)
          .eq('id_refaccion', item.idRefaccion as Object)
          .select()
          .single();

      final updatedItem = Refaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idRefaccion == updatedItem.idRefaccion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idRefaccion, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_refaccion', idRefaccion)
          .select()
          .single();

      final updatedItem = Refaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idRefaccion == updatedItem.idRefaccion ? updatedItem : x).toList(),
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
