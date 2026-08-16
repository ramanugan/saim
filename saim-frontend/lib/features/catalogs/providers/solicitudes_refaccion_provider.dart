import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/solicitud_refaccion.dart';

final helperIgualasForSolicitudProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala')
      .select('id_iguala, codigo_iguala')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperOrdenesForSolicitudProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('orden_servicio')
      .select('id_orden_servicio, folio_orden')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperUsuariosForSolicitudProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('usuario')
      .select('id_usuario, nombre_usuario')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final solicitudesRefaccionProvider = StateNotifierProvider<SolicitudesRefaccionNotifier, AsyncValue<List<SolicitudRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SolicitudesRefaccionNotifier(supabase);
});

class SolicitudesRefaccionNotifier extends StateNotifier<AsyncValue<List<SolicitudRefaccion>>> {
  final dynamic _supabase;

  SolicitudesRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchSolicitudes();
  }

  Future<void> fetchSolicitudes() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('solicitud_refaccion')
          .select()
          .order('id_solicitud_refaccion', ascending: false);
      
      final List<SolicitudRefaccion> list = (response as List)
          .map((json) => SolicitudRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addSolicitud(SolicitudRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('solicitud_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = SolicitudRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSolicitud(SolicitudRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_solicitud_refaccion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('solicitud_refaccion')
          .update(data)
          .eq('id_solicitud_refaccion', item.idSolicitudRefaccion as Object)
          .select()
          .single();

      final updatedItem = SolicitudRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSolicitudRefaccion == updatedItem.idSolicitudRefaccion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idSolicitud, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('solicitud_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_solicitud_refaccion', idSolicitud)
          .select()
          .single();

      final updatedItem = SolicitudRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSolicitudRefaccion == updatedItem.idSolicitudRefaccion ? updatedItem : x).toList(),
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
