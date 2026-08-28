import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/cliente.dart';

import '../../../../core/providers/base_crud_notifier.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final clientesProvider = StateNotifierProvider<ClientesNotifier, AsyncValue<List<Cliente>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ClientesNotifier(supabase);
});

class ClientesNotifier extends SupabaseCrudNotifier<Cliente> {
  ClientesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'cliente',
          primaryKey: 'id_cliente',
          fromJson: (json) => Cliente.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idCliente,
        );

  Future<void> fetchClientes() => fetch();
  Future<void> addCliente(Cliente cliente) => add(cliente);
  Future<void> updateCliente(Cliente cliente) => updateItem(cliente);
  Future<void> deleteCliente(int idCliente) => deleteItem(idCliente);
}
