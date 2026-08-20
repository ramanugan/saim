import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/zona_tienda.dart';

final zonasTiendaProvider = StateNotifierProvider<ZonasTiendaNotifier, AsyncValue<List<ZonaTienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasTiendaNotifier(supabase);
});

class ZonasTiendaNotifier extends StateNotifier<AsyncValue<List<ZonaTienda>>> {
  final dynamic _supabase;

  ZonasTiendaNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchZonasTienda();
  }

  Future<void> fetchZonasTienda() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('zona_tienda')
          .select()
          .eq('activo', true)
          .order('id_zona_tienda');

      final zonas = (response as List).map((e) => ZonaTienda.fromJson(e)).toList();
      state = AsyncValue.data(zonas);
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

  Future<void> addZonaTienda(ZonaTienda zona) async {
    try {
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      final data = zona.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('zona_tienda')
          .insert(data)
          .select()
          .single();

      final newZona = ZonaTienda.fromJson(response);
      state = AsyncValue.data([...currentZonas, newZona]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateZonaTienda(ZonaTienda zona) async {
    try {
      if (zona.idZonaTienda == null) return;
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      final data = zona.toJson();
      data['actualizado_por'] = idUsuario;
      data['actualizado_en'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('zona_tienda')
          .update(data)
          .eq('id_zona_tienda', zona.idZonaTienda as Object)
          .select()
          .single();

      final updatedZona = ZonaTienda.fromJson(response);
      state = AsyncValue.data(
        currentZonas
            .map((z) => z.idZonaTienda == zona.idZonaTienda ? updatedZona : z)
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteZonaTienda(int idZonaTienda) async {
    try {
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      await _supabase
          .from('zona_tienda')
          .update({'activo': false, 'actualizado_por': idUsuario})
          .eq('id_zona_tienda', idZonaTienda);

      state = AsyncValue.data(
        currentZonas.where((z) => z.idZonaTienda != idZonaTienda).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
