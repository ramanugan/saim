import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/suministro_refaccion_detalle.dart';

final helperSuministrosForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('suministro_refaccion')
      .select('id_suministro, documento_referencia, fuente_suministro')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperSolicitudDetallesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)');
  return List<Map<String, dynamic>>.from(response as List);
});

final suministrosRefaccionDetalleProvider = StateNotifierProvider<SuministrosRefaccionDetalleNotifier, AsyncValue<List<SuministroRefaccionDetalle>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SuministrosRefaccionDetalleNotifier(supabase);
});

class SuministrosRefaccionDetalleNotifier extends StateNotifier<AsyncValue<List<SuministroRefaccionDetalle>>> {
  final dynamic _supabase;

  SuministrosRefaccionDetalleNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchDetalles();
  }

  Future<void> fetchDetalles() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('suministro_refaccion_detalle')
          .select()
          .order('id_suministro_detalle', ascending: false);
      
      final List<SuministroRefaccionDetalle> list = (response as List)
          .map((json) => SuministroRefaccionDetalle.fromJson(json))
          .toList();
      
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addDetalle(SuministroRefaccionDetalle item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('suministro_refaccion_detalle')
          .insert(data)
          .select()
          .single();

      final newItem = SuministroRefaccionDetalle.fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDetalle(SuministroRefaccionDetalle item) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = item.toJson();
      data.remove('id_suministro_detalle');
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('suministro_refaccion_detalle')
          .update(data)
          .eq('id_suministro_detalle', item.idSuministroDetalle as Object)
          .select()
          .single();

      final updatedItem = SuministroRefaccionDetalle.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSuministroDetalle == updatedItem.idSuministroDetalle ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idSuministroDetalle, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('suministro_refaccion_detalle')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_suministro_detalle', idSuministroDetalle)
          .select()
          .single();

      final updatedItem = SuministroRefaccionDetalle.fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => x.idSuministroDetalle == updatedItem.idSuministroDetalle ? updatedItem : x).toList(),
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
