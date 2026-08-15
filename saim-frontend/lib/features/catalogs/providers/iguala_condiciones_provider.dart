import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/iguala_condicion.dart';

// Helper providers for foreign key dropdowns
final helperIgualasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala')
      .select('id_iguala, codigo_iguala')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperIgualaServiciosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala_servicio')
      .select('id_iguala_servicio, id_iguala, alcance_particular')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperPeriodicidadesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('periodicidad')
      .select('id_periodicidad, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final igualaCondicionesProvider = StateNotifierProvider<IgualaCondicionesNotifier, AsyncValue<List<IgualaCondicion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualaCondicionesNotifier(supabase);
});

class IgualaCondicionesNotifier extends StateNotifier<AsyncValue<List<IgualaCondicion>>> {
  final dynamic _supabase;

  IgualaCondicionesNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchIgualaCondiciones();
  }

  Future<void> fetchIgualaCondiciones() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('iguala_condicion')
          .select()
          .order('id_iguala_condicion', ascending: false);
      
      final List<IgualaCondicion> list = (response as List)
          .map((json) => IgualaCondicion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addIgualaCondicion(IgualaCondicion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('iguala_condicion')
          .insert(data)
          .select()
          .single();

      final newItem = IgualaCondicion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIgualaCondicion(IgualaCondicion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_iguala_condicion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('iguala_condicion')
          .update(data)
          .eq('id_iguala_condicion', item.idIgualaCondicion as Object)
          .select()
          .single();

      final updatedItem = IgualaCondicion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIgualaCondicion == updatedItem.idIgualaCondicion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idIgualaCondicion, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('iguala_condicion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_iguala_condicion', idIgualaCondicion)
          .select()
          .single();

      final updatedItem = IgualaCondicion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIgualaCondicion == updatedItem.idIgualaCondicion ? updatedItem : x).toList(),
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
