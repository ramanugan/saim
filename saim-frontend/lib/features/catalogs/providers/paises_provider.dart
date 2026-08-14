import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/pais.dart';

final paisesProvider = StateNotifierProvider<PaisesNotifier, AsyncValue<List<Pais>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return PaisesNotifier(supabase);
});

class PaisesNotifier extends StateNotifier<AsyncValue<List<Pais>>> {
  final dynamic _supabase;

  PaisesNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchPaises();
  }

  Future<void> fetchPaises() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('pais')
          .select()
          .order('nombre', ascending: true);
      
      final List<Pais> paises = (response as List)
          .map((json) => Pais.fromJson(json))
          .toList();
      
      state = AsyncValue.data(paises);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPais(Pais pais) async {
    try {
      final currentPaises = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = pais.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('pais')
          .insert(data)
          .select()
          .single();

      final newPais = Pais.fromJson(response);
      state = AsyncValue.data([...currentPaises, newPais]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePais(Pais pais) async {
    try {
      final currentPaises = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = pais.toJson();
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('pais')
          .update(data)
          .eq('id_pais', pais.idPais as Object)
          .select()
          .single();

      final updatedPais = Pais.fromJson(response);
      state = AsyncValue.data(
        currentPaises.map((p) => p.idPais == updatedPais.idPais ? updatedPais : p).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idPais, bool currentStatus) async {
    try {
      final currentPaises = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('pais')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_pais', idPais)
          .select()
          .single();

      final updatedPais = Pais.fromJson(response);
      state = AsyncValue.data(
        currentPaises.map((p) => p.idPais == updatedPais.idPais ? updatedPais : p).toList(),
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
