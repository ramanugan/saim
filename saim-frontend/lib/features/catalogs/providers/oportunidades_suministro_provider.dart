import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/oportunidad_suministro.dart';

final helperSolicitudDetallesForOportunidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)');
  return List<Map<String, dynamic>>.from(response as List);
});

final helperCotizacionesForOportunidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('cotizacion')
      .select('id_cotizacion, numero_cotizacion');
  return List<Map<String, dynamic>>.from(response as List);
});

final oportunidadesSuministroProvider = StateNotifierProvider<OportunidadesSuministroNotifier, AsyncValue<List<OportunidadSuministro>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return OportunidadesSuministroNotifier(supabase);
});

class OportunidadesSuministroNotifier extends StateNotifier<AsyncValue<List<OportunidadSuministro>>> {
  final dynamic _supabase;

  OportunidadesSuministroNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchOportunidades();
  }

  Future<void> fetchOportunidades() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('oportunidad_suministro')
          .select()
          .order('id_oportunidad', ascending: false);
      
      final List<OportunidadSuministro> list = (response as List)
          .map((json) => OportunidadSuministro.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addOportunidad(OportunidadSuministro item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('oportunidad_suministro')
          .insert(data)
          .select()
          .single();

      final newItem = OportunidadSuministro.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOportunidad(OportunidadSuministro item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_oportunidad');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('oportunidad_suministro')
          .update(data)
          .eq('id_oportunidad', item.idOportunidad as Object)
          .select()
          .single();

      final updatedItem = OportunidadSuministro.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idOportunidad == updatedItem.idOportunidad ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idOportunidad, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('oportunidad_suministro')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_oportunidad', idOportunidad)
          .select()
          .single();

      final updatedItem = OportunidadSuministro.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idOportunidad == updatedItem.idOportunidad ? updatedItem : x).toList(),
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
