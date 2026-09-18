import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/jornada_servicio.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'servicios_mantenimiento_provider.dart';

final helperServiciosForJornadaProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(serviciosMantenimientoProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final jornadasServicioProvider = StateNotifierProvider<JornadasServicioNotifier, AsyncValue<List<JornadaServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return JornadasServicioNotifier(supabase);
});

class JornadasServicioNotifier extends SupabaseCrudNotifier<JornadaServicio> {
  JornadasServicioNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'jornada_servicio',
          primaryKey: 'id_jornada',
          fromJson: (json) => JornadaServicio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idJornada,
        );

  Future<void> fetchJornadasServicio() => fetch();
  Future<void> addJornadaServicio(JornadaServicio item) => add(item);
  Future<void> updateJornadaServicio(JornadaServicio item) => updateItem(item);
  Future<void> deleteJornadaServicio(int id) => deleteItem(id);
}
