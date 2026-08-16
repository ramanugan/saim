import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/suministro_refaccion.dart';

final helperSolicitudesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion')
      .select('id_solicitud_refaccion, folio')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperProveedoresForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperAlmacenesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('almacen')
      .select('id_almacen, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final suministrosRefaccionProvider = StateNotifierProvider<SuministrosRefaccionNotifier, AsyncValue<List<SuministroRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SuministrosRefaccionNotifier(supabase);
});

class SuministrosRefaccionNotifier extends StateNotifier<AsyncValue<List<SuministroRefaccion>>> {
  final dynamic _supabase;

  SuministrosRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchSuministros();
  }

  Future<void> fetchSuministros() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('suministro_refaccion')
          .select()
          .order('id_suministro', ascending: false);
      
      final List<SuministroRefaccion> list = (response as List)
          .map((json) => SuministroRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addSuministro(SuministroRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('suministro_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = SuministroRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSuministro(SuministroRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_suministro');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('suministro_refaccion')
          .update(data)
          .eq('id_suministro', item.idSuministro as Object)
          .select()
          .single();

      final updatedItem = SuministroRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSuministro == updatedItem.idSuministro ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idSuministro, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('suministro_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_suministro', idSuministro)
          .select()
          .single();

      final updatedItem = SuministroRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSuministro == updatedItem.idSuministro ? updatedItem : x).toList(),
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
