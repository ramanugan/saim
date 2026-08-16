import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/instalacion_refaccion.dart';

final helperSolicitudDetallesForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperOrdenesForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('orden_servicio')
      .select('id_orden_servicio, folio_orden')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperEquiposForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('equipo')
      .select('id_equipo, codigo_activo_cliente, marca, modelo')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final instalacionesRefaccionProvider = StateNotifierProvider<InstalacionesRefaccionNotifier, AsyncValue<List<InstalacionRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return InstalacionesRefaccionNotifier(supabase);
});

class InstalacionesRefaccionNotifier extends StateNotifier<AsyncValue<List<InstalacionRefaccion>>> {
  final dynamic _supabase;

  InstalacionesRefaccionNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchInstalaciones();
  }

  Future<void> fetchInstalaciones() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('instalacion_refaccion')
          .select()
          .order('id_instalacion', ascending: false);
      
      final List<InstalacionRefaccion> list = (response as List)
          .map((json) => InstalacionRefaccion.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addInstalacion(InstalacionRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('instalacion_refaccion')
          .insert(data)
          .select()
          .single();

      final newItem = InstalacionRefaccion.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateInstalacion(InstalacionRefaccion item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_instalacion');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('instalacion_refaccion')
          .update(data)
          .eq('id_instalacion', item.idInstalacion as Object)
          .select()
          .single();

      final updatedItem = InstalacionRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idInstalacion == updatedItem.idInstalacion ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idInstalacion, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('instalacion_refaccion')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_instalacion', idInstalacion)
          .select()
          .single();

      final updatedItem = InstalacionRefaccion.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idInstalacion == updatedItem.idInstalacion ? updatedItem : x).toList(),
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
