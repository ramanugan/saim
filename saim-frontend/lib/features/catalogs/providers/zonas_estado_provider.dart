import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/zona_estado.dart';

final zonasEstadoProvider = StateNotifierProvider<ZonasEstadoNotifier, AsyncValue<List<ZonaEstado>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasEstadoNotifier(supabase);
});

class ZonasEstadoNotifier extends StateNotifier<AsyncValue<List<ZonaEstado>>> {
  final dynamic _supabase;

  ZonasEstadoNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchZonasEstado();
  }

  Future<void> fetchZonasEstado() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('zona_estado')
          .select()
          .eq('activo', true)
          .order('id_zona_estado');
          
      final zonas = (response as List).map((e) => ZonaEstado.fromJson(e)).toList();
      state = AsyncValue.data(zonas);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addZonaEstado(ZonaEstado zona) async {
    try {
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      final Map<String, dynamic> data = {
        'id_zona_contrato': zona.idZonaContrato,
        'id_estado': zona.idEstado,
        'fecha_inicio': zona.fechaInicio.toIso8601String(),
        'fecha_fin': zona.fechaFin?.toIso8601String(),
        'es_excepcion': zona.esExcepcion,
        'justificacion': zona.justificacion,
        'activo': zona.activo,
        'creado_por': idUsuario,
        'actualizado_por': idUsuario,
      };

      final response = await _supabase
          .from('zona_estado')
          .insert(data)
          .select()
          .single();

      final newZona = ZonaEstado.fromJson(response);
      state = AsyncValue.data([...currentZonas, newZona]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateZonaEstado(ZonaEstado zona) async {
    try {
      if (zona.idZonaEstado == null) return;
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final Map<String, dynamic> data = {
        'id_zona_contrato': zona.idZonaContrato,
        'id_estado': zona.idEstado,
        'fecha_inicio': zona.fechaInicio.toIso8601String(),
        'fecha_fin': zona.fechaFin?.toIso8601String(),
        'es_excepcion': zona.esExcepcion,
        'justificacion': zona.justificacion,
        'activo': zona.activo,
        'actualizado_por': idUsuario,
      };

      final response = await _supabase
          .from('zona_estado')
          .update(data)
          .eq('id_zona_estado', zona.idZonaEstado as Object)
          .select()
          .single();

      final updatedZona = ZonaEstado.fromJson(response);
      state = AsyncValue.data(
        currentZonas.map((z) => z.idZonaEstado == zona.idZonaEstado ? updatedZona : z).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteZonaEstado(int idZonaEstado) async {
    try {
      final currentZonas = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      await _supabase
          .from('zona_estado')
          .update({'activo': false, 'actualizado_por': idUsuario})
          .eq('id_zona_estado', idZonaEstado);

      state = AsyncValue.data(
        currentZonas.where((z) => z.idZonaEstado != idZonaEstado).toList(),
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
