import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/municipio.dart';

final municipiosProvider = StateNotifierProvider<MunicipiosNotifier, AsyncValue<List<Municipio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return MunicipiosNotifier(supabase);
});

class MunicipiosNotifier extends StateNotifier<AsyncValue<List<Municipio>>> {
  final dynamic _supabase;

  MunicipiosNotifier(this._supabase) : super(const AsyncValue.loading()) {
    fetchMunicipios();
  }

  Future<void> fetchMunicipios() async {
    try {
      state = const AsyncValue.loading();
      final response = await _supabase
          .from('municipio')
          .select()
          .order('nombre', ascending: true);
      
      final List<Municipio> municipios = (response as List)
          .map((json) => Municipio.fromJson(json))
          .toList();
      
      state = AsyncValue.data(municipios);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addMunicipio(Municipio municipio) async {
    try {
      final currentMunicipios = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = municipio.toJson();
      data['creado_por'] = idUsuario;
      data['actualizado_por'] = idUsuario;

      final response = await _supabase
          .from('municipio')
          .insert(data)
          .select()
          .single();

      final newMunicipio = Municipio.fromJson(response);
      state = AsyncValue.data([...currentMunicipios, newMunicipio]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMunicipio(Municipio municipio) async {
    try {
      final currentMunicipios = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final data = municipio.toJson();
      data['actualizado_por'] = idUsuario;
      
      final response = await _supabase
          .from('municipio')
          .update(data)
          .eq('id_municipio', municipio.idMunicipio as Object)
          .select()
          .single();

      final updatedMunicipio = Municipio.fromJson(response);
      state = AsyncValue.data(
        currentMunicipios.map((m) => m.idMunicipio == updatedMunicipio.idMunicipio ? updatedMunicipio : m).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleStatus(int idMunicipio, bool currentStatus) async {
    try {
      final currentMunicipios = state.value ?? [];
      final idUsuario = await _getCurrentUserId();
      
      final response = await _supabase
          .from('municipio')
          .update({
            'activo': !currentStatus,
            'actualizado_por': idUsuario,
          })
          .eq('id_municipio', idMunicipio)
          .select()
          .single();

      final updatedMunicipio = Municipio.fromJson(response);
      state = AsyncValue.data(
        currentMunicipios.map((m) => m.idMunicipio == updatedMunicipio.idMunicipio ? updatedMunicipio : m).toList(),
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
