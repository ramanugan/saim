import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/cliente.dart';

final clientesProvider = StateNotifierProvider<ClientesNotifier, AsyncValue<List<Cliente>>>((ref) {
  return ClientesNotifier(ref);
});

class ClientesNotifier extends StateNotifier<AsyncValue<List<Cliente>>> {
  final Ref ref;

  ClientesNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    try {
      state = const AsyncValue.loading();
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase
          .from('cliente')
          .select()
          .order('id_cliente', ascending: true);
          
      final clientes = (response as List).map((json) => Cliente.fromJson(json)).toList();
      state = AsyncValue.data(clientes);
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
    return 1; // Fallback if not found
  }

  Future<void> addCliente(Cliente cliente) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final userIdInt = await _getCurrentUserId();

      final data = cliente.toJson();
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;
      
      await supabase.from('cliente').insert(data);
      await fetchClientes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCliente(Cliente cliente) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final userIdInt = await _getCurrentUserId();

      final data = cliente.toJson();
      data['actualizado_por'] = userIdInt;
      data['actualizado_en'] = DateTime.now().toIso8601String();
      
      await supabase
          .from('cliente')
          .update(data)
          .eq('id_cliente', cliente.idCliente!);
          
      await fetchClientes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCliente(int idCliente) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      // Soft delete
      await supabase
          .from('cliente')
          .update({'activo': false})
          .eq('id_cliente', idCliente);
          
      await fetchClientes();
    } catch (e) {
      rethrow;
    }
  }
}
