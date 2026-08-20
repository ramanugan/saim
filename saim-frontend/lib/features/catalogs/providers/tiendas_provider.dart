import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/tienda.dart';

final tiendasProvider = StateNotifierProvider<TiendasNotifier, AsyncValue<List<Tienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiendasNotifier(supabase);
});

/// Helper para dropdowns — lista de tiendas activas como Map
final helperTiendasProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(tiendasProvider);
  return state.when(
    data: (list) => AsyncValue.data(
      list.where((t) => t.activo).map((t) => {
        'id': t.idTienda,
        'nombre': '${t.codigo} - ${t.nombre}',
        'id_cliente': t.idCliente,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class TiendasNotifier extends StateNotifier<AsyncValue<List<Tienda>>> {
  final dynamic _supabase;

  TiendasNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchTiendas();
  }

  Future<void> fetchTiendas() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('tienda')
          .select()
          .order('id_tienda', ascending: true);

      final tiendas = (response as List).map((json) => Tienda.fromJson(json)).toList();
      state = AsyncValue.data(tiendas);
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

  Future<void> addTienda(Tienda tienda) async {
    try {
      final idUsuario = await _getCurrentUserId();
      final data = tienda.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      await _supabase.from('tienda').insert(data);
      await fetchTiendas();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTienda(Tienda tienda) async {
    try {
      if (tienda.idTienda == null) return;
      final idUsuario = await _getCurrentUserId();
      final data = tienda.toJson();
      data['actualizado_por'] = idUsuario;
      data['actualizado_en'] = DateTime.now().toIso8601String();

      await _supabase
          .from('tienda')
          .update(data)
          .eq('id_tienda', tienda.idTienda as Object);
      await fetchTiendas();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTienda(int idTienda) async {
    try {
      final idUsuario = await _getCurrentUserId();
      await _supabase
          .from('tienda')
          .update({'activo': false, 'actualizado_por': idUsuario})
          .eq('id_tienda', idTienda);
      await fetchTiendas();
    } catch (e) {
      rethrow;
    }
  }
}
