import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/contrato.dart';

final contratosProvider = StateNotifierProvider<ContratosNotifier, AsyncValue<List<Contrato>>>((ref) {
  return ContratosNotifier(ref);
});

class ContratosNotifier extends StateNotifier<AsyncValue<List<Contrato>>> {
  final Ref ref;

  ContratosNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchContratos();
  }

  Future<void> fetchContratos() async {
    try {
      state = const AsyncValue.loading();
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase
          .from('contrato')
          .select()
          .order('id_contrato', ascending: true);
          
      final contratos = (response as List).map((json) => Contrato.fromJson(json)).toList();
      state = AsyncValue.data(contratos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> _getCurrentUserId() async {
    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;
    if (user == null || user.email == null) return 1; // Fallback
    try {
      final response = await supabase
          .from('usuario')
          .select('id_usuario')
          .eq('correo', user.email!)
          .maybeSingle();
      if (response != null) {
        return response['id_usuario'] as int;
      }
    } catch (_) {}
    return 1;
  }

  Future<void> addContrato(Contrato contrato) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final userIdInt = await _getCurrentUserId();

      final data = contrato.toJson();
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;
      
      await supabase.from('contrato').insert(data);
      await fetchContratos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContrato(Contrato contrato) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final userIdInt = await _getCurrentUserId();

      final data = contrato.toJson();
      data['actualizado_por'] = userIdInt;
      data['actualizado_en'] = DateTime.now().toIso8601String();
      
      await supabase
          .from('contrato')
          .update(data)
          .eq('id_contrato', contrato.idContrato!);
          
      await fetchContratos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteContrato(int idContrato) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase
          .from('contrato')
          .update({'activo': false})
          .eq('id_contrato', idContrato);
          
      await fetchContratos();
    } catch (e) {
      rethrow;
    }
  }
}
