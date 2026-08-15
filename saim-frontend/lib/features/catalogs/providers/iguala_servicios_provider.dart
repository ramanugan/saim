import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/iguala_servicio.dart';

final helperIgualasForServicioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala')
      .select('id_iguala, codigo_iguala')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposServicioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tipo_servicio')
      .select('id_tipo_servicio, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final igualaServiciosProvider = StateNotifierProvider<IgualaServiciosNotifier, AsyncValue<List<IgualaServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualaServiciosNotifier(supabase);
});

class IgualaServiciosNotifier extends StateNotifier<AsyncValue<List<IgualaServicio>>> {
  final dynamic _supabase;

  IgualaServiciosNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchIgualaServicios();
  }

  Future<void> fetchIgualaServicios() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('iguala_servicio')
          .select()
          .order('id_iguala_servicio', ascending: false);
      
      final List<IgualaServicio> list = (response as List)
          .map((json) => IgualaServicio.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addIgualaServicio(IgualaServicio item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('iguala_servicio')
          .insert(data)
          .select()
          .single();

      final newItem = IgualaServicio.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIgualaServicio(IgualaServicio item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_iguala_servicio');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('iguala_servicio')
          .update(data)
          .eq('id_iguala_servicio', item.idIgualaServicio as Object)
          .select()
          .single();

      final updatedItem = IgualaServicio.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIgualaServicio == updatedItem.idIgualaServicio ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idIgualaServicio, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('iguala_servicio')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_iguala_servicio', idIgualaServicio)
          .select()
          .single();

      final updatedItem = IgualaServicio.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idIgualaServicio == updatedItem.idIgualaServicio ? updatedItem : x).toList(),
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
