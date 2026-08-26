import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/equipo.dart';

final equiposProvider = StateNotifierProvider<EquiposNotifier, AsyncValue<List<Equipo>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EquiposNotifier(supabase);
});

class EquiposNotifier extends StateNotifier<AsyncValue<List<Equipo>>> {
  final dynamic _supabase;

  EquiposNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchEquipos();
  }

  Future<void> fetchEquipos() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('equipo')
          .select('*, tienda(nombre), tipo_equipo(nombre)')
          .order('id_equipo', ascending: true);

      final equipos = (response as List).map((json) {
        // Aplanar los datos relacionales de Supabase para el fromJson
        final Map<String, dynamic> flatJson = Map<String, dynamic>.from(json);
        if (flatJson['tienda'] != null && flatJson['tienda'] is Map) {
          flatJson['nombre_tienda'] = flatJson['tienda']['nombre'];
        }
        if (flatJson['tipo_equipo'] != null && flatJson['tipo_equipo'] is Map) {
          flatJson['nombre_tipo_equipo'] = flatJson['tipo_equipo']['nombre'];
        }
        return Equipo.fromJson(flatJson);
      }).toList();
      
      state = AsyncValue.data(equipos);
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

  Future<void> addEquipo(Equipo equipo) async {
    try {
      final idUsuario = await _getCurrentUserId();
      final data = equipo.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      await _supabase.from('equipo').insert(data);
      await fetchEquipos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEquipo(Equipo equipo) async {
    try {
      if (equipo.idEquipo == null) return;
      final idUsuario = await _getCurrentUserId();
      final data = equipo.toJson();
      data['actualizado_por'] = idUsuario;
      data['actualizado_en'] = DateTime.now().toIso8601String();

      await _supabase
          .from('equipo')
          .update(data)
          .eq('id_equipo', equipo.idEquipo as Object);
      await fetchEquipos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEquipo(int idEquipo) async {
    try {
      final idUsuario = await _getCurrentUserId();
      await _supabase
          .from('equipo')
          .update({'activo': false, 'actualizado_por': idUsuario})
          .eq('id_equipo', idEquipo);
      await fetchEquipos();
    } catch (e) {
      rethrow;
    }
  }
}
