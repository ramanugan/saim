import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/pais.dart';

final paisesProvider = StateNotifierProvider<PaisesNotifier, AsyncValue<List<Pais>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return PaisesNotifier(supabase);
});

class PaisesNotifier extends SupabaseCrudNotifier<Pais> {
  PaisesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'pais',
          primaryKey: 'id_pais',
          ascending: true,
          orderBy: 'nombre',
          fromJson: (json) => Pais.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idPais,
        );

  Future<void> fetchPaises() => fetch();
  Future<void> addPais(Pais item) => add(item);
  Future<void> updatePais(Pais item) => updateItem(item);
}
