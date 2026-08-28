import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/contrato.dart';

final contratosProvider = StateNotifierProvider<ContratosNotifier, AsyncValue<List<Contrato>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ContratosNotifier(supabase);
});

class ContratosNotifier extends SupabaseCrudNotifier<Contrato> {
  ContratosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'contrato',
          primaryKey: 'id_contrato',
          ascending: true,
          fromJson: (json) => Contrato.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idContrato,
        );

  Future<void> fetchContratos() => fetch();
  Future<void> addContrato(Contrato item) => add(item);
  Future<void> updateContrato(Contrato item) => updateItem(item);
  Future<void> deleteContrato(int idContrato) => toggleStatus(idContrato, true); // sets activo to false
}
