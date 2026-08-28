import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/municipio.dart';

final municipiosProvider = StateNotifierProvider<MunicipiosNotifier, AsyncValue<List<Municipio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return MunicipiosNotifier(supabase);
});

final helperMunicipiosProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final municipiosState = ref.watch(municipiosProvider);

  return municipiosState.when(
    data: (list) => AsyncValue.data(
      list.map((m) => {
        'id': m.idMunicipio,
        'nombre': m.nombre,
        'activo': m.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class MunicipiosNotifier extends SupabaseCrudNotifier<Municipio> {
  MunicipiosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'municipio',
          primaryKey: 'id_municipio',
          ascending: true,
          orderBy: 'nombre',
          fromJson: (json) => Municipio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idMunicipio,
        );

  Future<void> fetchMunicipios() => fetch();
  Future<void> addMunicipio(Municipio item) => add(item);
  Future<void> updateMunicipio(Municipio item) => updateItem(item);
}
