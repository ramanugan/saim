import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/refaccion_compatibilidad.dart';

final helperRefaccionesForCompatibilidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposEquipoForCompatibilidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tipo_equipo')
      .select('id_tipo_equipo, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final refaccionesCompatibilidadProvider = StateNotifierProvider<RefaccionesCompatibilidadNotifier, AsyncValue<List<RefaccionCompatibilidad>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesCompatibilidadNotifier(supabase);
});

class RefaccionesCompatibilidadNotifier extends StateNotifier<AsyncValue<List<RefaccionCompatibilidad>>> {
  final dynamic _supabase;

  RefaccionesCompatibilidadNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchCompatibilidades();
  }

  Future<void> fetchCompatibilidades() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('refaccion_compatibilidad')
          .select()
          .order('id_compatibilidad', ascending: false);
      
      final List<RefaccionCompatibilidad> list = (response as List)
          .map((json) => RefaccionCompatibilidad.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addCompatibilidad(RefaccionCompatibilidad item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('refaccion_compatibilidad')
          .insert(data)
          .select()
          .single();

      final newItem = RefaccionCompatibilidad.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCompatibilidad(RefaccionCompatibilidad item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_compatibilidad');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('refaccion_compatibilidad')
          .update(data)
          .eq('id_compatibilidad', item.idCompatibilidad as Object)
          .select()
          .single();

      final updatedItem = RefaccionCompatibilidad.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idCompatibilidad == updatedItem.idCompatibilidad ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idCompatibilidad, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('refaccion_compatibilidad')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_compatibilidad', idCompatibilidad)
          .select()
          .single();

      final updatedItem = RefaccionCompatibilidad.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idCompatibilidad == updatedItem.idCompatibilidad ? updatedItem : x).toList(),
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
