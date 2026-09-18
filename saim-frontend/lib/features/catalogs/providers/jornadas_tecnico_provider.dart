import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/jornada_tecnico.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'jornadas_servicio_provider.dart';
import 'empleados_provider.dart';

final helperJornadasForTecnicoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(jornadasServicioProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

// Reuse helperEmpleadosForMiembroProvider from cuadrilla_miembros_provider or create it here if needed.
// Since it's better to keep it isolated, let's create a local one for tecnico.
final helperEmpleadosForJornadaProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(empleadosProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final jornadasTecnicoProvider = StateNotifierProvider<JornadasTecnicoNotifier, AsyncValue<List<JornadaTecnico>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return JornadasTecnicoNotifier(supabase);
});

class JornadasTecnicoNotifier extends SupabaseCrudNotifier<JornadaTecnico> {
  JornadasTecnicoNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'jornada_tecnico',
          primaryKey: 'id_jornada_tecnico',
          fromJson: (json) => JornadaTecnico.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idJornadaTecnico,
        );

  Future<void> fetchJornadasTecnico() => fetch();
  Future<void> addJornadaTecnico(JornadaTecnico item) => add(item);
  Future<void> updateJornadaTecnico(JornadaTecnico item) => updateItem(item);
  Future<void> deleteJornadaTecnico(int id) => deleteItem(id);
}
