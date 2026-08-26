import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/tipo_equipo.dart';

final tiposEquipoProvider = StateNotifierProvider<TiposEquipoNotifier, AsyncValue<List<TipoEquipo>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposEquipoNotifier(supabase);
});

/// Helper para dropdowns — lista de tipos de equipo activos como Map
final helperTiposEquipoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(tiposEquipoProvider);
  return state.when(
    data: (list) => AsyncValue.data(
      list.where((t) => t.activo).map((t) => {
        'id': t.idTipoEquipo,
        'nombre': '${t.codigo} - ${t.nombre}',
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class TiposEquipoNotifier extends StateNotifier<AsyncValue<List<TipoEquipo>>> {
  final dynamic _supabase;

  TiposEquipoNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchTiposEquipo();
  }

  Future<void> fetchTiposEquipo() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('tipo_equipo')
          .select()
          .order('id_tipo_equipo', ascending: true);

      final tipos = (response as List).map((json) => TipoEquipo.fromJson(json)).toList();
      state = AsyncValue.data(tipos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> _getCurrentUserId() async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser != null) {
        final res = await _supabase
            .from('usuario')
            .select('id_usuario')
            .eq('correo', authUser.email as Object)
            .maybeSingle();
        if (res != null) return res['id_usuario'] as int;
      }
    } catch (_) {}
    return 1;
  }

  Future<void> addTipoEquipo(TipoEquipo tipo) async {
    try {
      final idUsuario = await _getCurrentUserId();
      final data = tipo.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      await _supabase.from('tipo_equipo').insert(data);
      await fetchTiposEquipo();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTipoEquipo(TipoEquipo tipo) async {
    try {
      if (tipo.idTipoEquipo == null) return;
      final idUsuario = await _getCurrentUserId();
      final data = tipo.toJson();
      data['actualizado_por'] = idUsuario;
      data['actualizado_en'] = DateTime.now().toIso8601String();

      await _supabase
          .from('tipo_equipo')
          .update(data)
          .eq('id_tipo_equipo', tipo.idTipoEquipo as Object);
      await fetchTiposEquipo();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTipoEquipo(int idTipoEquipo) async {
    try {
      final idUsuario = await _getCurrentUserId();
      await _supabase
          .from('tipo_equipo')
          .update({'activo': false, 'actualizado_por': idUsuario})
          .eq('id_tipo_equipo', idTipoEquipo);
      await fetchTiposEquipo();
    } catch (e) {
      rethrow;
    }
  }
}
