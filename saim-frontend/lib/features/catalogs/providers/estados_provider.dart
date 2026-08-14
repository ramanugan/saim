import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/estado.dart';

final estadosProvider = StateNotifierProvider<EstadosNotifier, AsyncValue<List<Estado>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EstadosNotifier(supabase);
});

class EstadosNotifier extends StateNotifier<AsyncValue<List<Estado>>> {
  final dynamic _supabase;

  EstadosNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchEstados();
  }

  Future<void> fetchEstados() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('estado')
          .select()
          .eq('activo', true)
          .order('id_estado');
          
      final estados = (response as List).map((e) => Estado.fromJson(e)).toList();
      state = AsyncValue.data(estados);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addEstado(Estado estado) async {
    try {
      final currentEstados = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      final Map<String, dynamic> data = {
        'id_pais': estado.idPais,
        'clave_inegi': estado.claveInegi,
        'nombre': estado.nombre,
        'activo': estado.activo,
        'creado_por': idUsuario,
        'actualizado_por': idUsuario,
      };

      final response = await _supabase
          .from('estado')
          .insert(data)
          .select()
          .single();

      final newEstado = Estado.fromJson(response);
      state = AsyncValue.data([...currentEstados, newEstado]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEstado(Estado estado) async {
    try {
      if (estado.idEstado == null) return;
      final currentEstados = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final Map<String, dynamic> data = {
        'id_pais': estado.idPais,
        'clave_inegi': estado.claveInegi,
        'nombre': estado.nombre,
        'activo': estado.activo,
        'actualizado_por': idUsuario,
      };

      final response = await _supabase
          .from('estado')
          .update(data)
          .eq('id_estado', estado.idEstado as Object)
          .select()
          .single();

      final updatedEstado = Estado.fromJson(response);
      state = AsyncValue.data(
        currentEstados.map((e) => e.idEstado == estado.idEstado ? updatedEstado : e).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idEstado, bool currentStatus) async {
    try {
      final currentEstados = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('estado')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario
          })
          .eq('id_estado', idEstado)
          .select()
          .single();

      final updatedEstado = Estado.fromJson(response);
      state = AsyncValue.data(
        currentEstados.map((e) => e.idEstado == updatedEstado.idEstado ? updatedEstado : e).toList(),
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
