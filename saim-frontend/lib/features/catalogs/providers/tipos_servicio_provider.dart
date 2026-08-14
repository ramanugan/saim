import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/tipo_servicio.dart';

final tiposServicioProvider = StateNotifierProvider<TiposServicioNotifier, AsyncValue<List<TipoServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposServicioNotifier(supabase);
});

class TiposServicioNotifier extends StateNotifier<AsyncValue<List<TipoServicio>>> {
  final dynamic _supabase;

  TiposServicioNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchTiposServicio();
  }

  Future<void> fetchTiposServicio() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('tipo_servicio')
          .select()
          .order('nombre', ascending: true);
      
      final List<TipoServicio> tipos = (response as List)
          .map((json) => TipoServicio.fromJson(json))
          .toList();
      
      state = AsyncValue.data(tipos);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTipoServicio(TipoServicio tipoServicio) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = tipoServicio.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('tipo_servicio')
          .insert(data)
          .select()
          .single();

      final newTipo = TipoServicio.fromJson(response);
      state = AsyncValue.data([...currentTipos, newTipo]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTipoServicio(TipoServicio tipoServicio) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = tipoServicio.toJson();
      data.remove('id_tipo_servicio');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('tipo_servicio')
          .update(data)
          .eq('id_tipo_servicio', tipoServicio.idTipoServicio as Object)
          .select()
          .single();

      final updatedTipo = TipoServicio.fromJson(response);
      state = AsyncValue.data(
        currentTipos.map((t) => t.idTipoServicio == updatedTipo.idTipoServicio ? updatedTipo : t).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idTipoServicio, bool currentStatus) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('tipo_servicio')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_tipo_servicio', idTipoServicio)
          .select()
          .single();

      final updatedTipo = TipoServicio.fromJson(response);
      state = AsyncValue.data(
        currentTipos.map((t) => t.idTipoServicio == updatedTipo.idTipoServicio ? updatedTipo : t).toList(),
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
