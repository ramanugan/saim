import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/iguala.dart';

final helperTiendasForIgualaProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tienda')
      .select('id_tienda, nombre, determinante')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposServicioForIgualaProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tipo_servicio')
      .select('id_tipo_servicio, nombre, codigo')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final igualasProvider = StateNotifierProvider<IgualasNotifier, AsyncValue<List<Iguala>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualasNotifier(supabase);
});

class IgualasNotifier extends StateNotifier<AsyncValue<List<Iguala>>> {
  final dynamic _supabase;

  IgualasNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchIgualas();
  }

  Future<void> fetchIgualas() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('iguala')
          .select()
          .order('id_iguala', ascending: false);
      
      final List<Iguala> list = (response as List)
          .map((json) => Iguala.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addIguala(Iguala iguala) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = iguala.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('iguala')
          .insert(data)
          .select()
          .single();

      final newItem = Iguala.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIguala(Iguala iguala) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = iguala.toJson();
      data.remove('id_iguala');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('iguala')
          .update(data)
          .eq('id_iguala', iguala.idIguala as Object)
          .select()
          .single();

      final updatedItem = Iguala.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIguala == updatedItem.idIguala ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idIguala, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('iguala')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_iguala', idIguala)
          .select()
          .single();

      final updatedItem = Iguala.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIguala == updatedItem.idIguala ? updatedItem : x).toList(),
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
