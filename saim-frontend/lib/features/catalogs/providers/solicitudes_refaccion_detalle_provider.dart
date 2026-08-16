import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/solicitud_refaccion_detalle.dart';

final helperSolicitudesForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion')
      .select('id_solicitud_refaccion, folio')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperEquiposForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('equipo')
      .select('id_equipo, codigo_activo_cliente, marca, modelo')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final solicitudesRefaccionDetalleProvider = StateNotifierProvider<SolicitudesRefaccionDetalleNotifier, AsyncValue<List<SolicitudRefaccionDetalle>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SolicitudesRefaccionDetalleNotifier(supabase);
});

class SolicitudesRefaccionDetalleNotifier extends StateNotifier<AsyncValue<List<SolicitudRefaccionDetalle>>> {
  final dynamic _supabase;

  SolicitudesRefaccionDetalleNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchDetalles();
  }

  Future<void> fetchDetalles() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('solicitud_refaccion_detalle')
          .select()
          .order('id_solicitud_refaccion_detalle', ascending: false);
      
      final List<SolicitudRefaccionDetalle> list = (response as List)
          .map((json) => SolicitudRefaccionDetalle.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addDetalle(SolicitudRefaccionDetalle item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('solicitud_refaccion_detalle')
          .insert(data)
          .select()
          .single();

      final newItem = SolicitudRefaccionDetalle.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDetalle(SolicitudRefaccionDetalle item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_solicitud_refaccion_detalle');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('solicitud_refaccion_detalle')
          .update(data)
          .eq('id_solicitud_refaccion_detalle', item.idSolicitudRefaccionDetalle as Object)
          .select()
          .single();

      final updatedItem = SolicitudRefaccionDetalle.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSolicitudRefaccionDetalle == updatedItem.idSolicitudRefaccionDetalle ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idSolicitudDetalle, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('solicitud_refaccion_detalle')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_solicitud_refaccion_detalle', idSolicitudDetalle)
          .select()
          .single();

      final updatedItem = SolicitudRefaccionDetalle.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSolicitudRefaccionDetalle == updatedItem.idSolicitudRefaccionDetalle ? updatedItem : x).toList(),
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
