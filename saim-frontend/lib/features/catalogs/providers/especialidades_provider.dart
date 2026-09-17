import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/especialidad.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final especialidadesProvider = StateNotifierProvider<EspecialidadesNotifier, AsyncValue<List<Especialidad>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EspecialidadesNotifier(supabase);
});

class EspecialidadesNotifier extends SupabaseCrudNotifier<Especialidad> {
  EspecialidadesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'especialidad',
          primaryKey: 'id_especialidad',
          fromJson: (json) => Especialidad.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idEspecialidad,
        );

  Future<void> fetchEspecialidades() => fetch();
  Future<void> addEspecialidad(Especialidad esp) => add(esp);
  Future<void> updateEspecialidad(Especialidad esp) => updateItem(esp);
  Future<void> deleteEspecialidad(int id) => deleteItem(id);
}

final helperEspecialidadesProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(especialidadesProvider);
  
  return state.when(
    data: (especialidades) {
      final actives = especialidades.where((e) => e.activo).toList();
      return AsyncValue.data(
        actives.map((e) => {
          'id': e.idEspecialidad,
          'nombre': e.nombre,
          'codigo': e.codigo,
        }).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
