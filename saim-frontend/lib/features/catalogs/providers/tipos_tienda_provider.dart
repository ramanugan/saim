import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/tipo_tienda.dart';

final tiposTiendaProvider = StateNotifierProvider<TiposTiendaNotifier, AsyncValue<List<TipoTienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposTiendaNotifier(supabase);
});

class TiposTiendaNotifier extends StateNotifier<AsyncValue<List<TipoTienda>>> {
  final dynamic _supabase;

  TiposTiendaNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchTiposTienda();
  }

  Future<void> fetchTiposTienda() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('tipo_tienda')
          .select()
          .order('nombre', ascending: true);
      
      final List<TipoTienda> tipos = (response as List)
          .map((json) => TipoTienda.fromJson(json))
          .toList();
      
      state = AsyncValue.data(tipos);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTipoTienda(TipoTienda tipoTienda) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = tipoTienda.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('tipo_tienda')
          .insert(data)
          .select()
          .single();

      final newTipo = TipoTienda.fromJson(response);
      state = AsyncValue.data([...currentTipos, newTipo]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTipoTienda(TipoTienda tipoTienda) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = tipoTienda.toJson();
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('tipo_tienda')
          .update(data)
          .eq('id_tipo_tienda', tipoTienda.idTipoTienda as Object)
          .select()
          .single();

      final updatedTipo = TipoTienda.fromJson(response);
      state = AsyncValue.data(
        currentTipos.map((t) => t.idTipoTienda == updatedTipo.idTipoTienda ? updatedTipo : t).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idTipoTienda, bool currentStatus) async {
    try {
      final currentTipos = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('tipo_tienda')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_tipo_tienda', idTipoTienda)
          .select()
          .single();

      final updatedTipo = TipoTienda.fromJson(response);
      state = AsyncValue.data(
        currentTipos.map((t) => t.idTipoTienda == updatedTipo.idTipoTienda ? updatedTipo : t).toList(),
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
