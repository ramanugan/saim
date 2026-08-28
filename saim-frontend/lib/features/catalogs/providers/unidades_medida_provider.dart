import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/unidad_medida.dart';

final unidadesMedidaProvider = StateNotifierProvider<UnidadesMedidaNotifier, AsyncValue<List<UnidadMedida>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return UnidadesMedidaNotifier(supabase);
});

class UnidadesMedidaNotifier extends SupabaseCrudNotifier<UnidadMedida> {
  UnidadesMedidaNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'unidad_medida',
          primaryKey: 'id_unidad_medida',
          ascending: false,
          fromJson: (json) => UnidadMedida.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idUnidadMedida,
        );

  Future<void> fetchUnidadesMedida() => fetch();
  Future<void> addUnidadMedida(UnidadMedida item) => add(item);
  Future<void> updateUnidadMedida(UnidadMedida item) => updateItem(item);
}
