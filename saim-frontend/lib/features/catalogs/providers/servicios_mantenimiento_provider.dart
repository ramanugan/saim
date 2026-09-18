import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/servicio_mantenimiento.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviciosMantenimientoProvider = StateNotifierProvider<ServiciosMantenimientoNotifier, AsyncValue<List<ServicioMantenimiento>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ServiciosMantenimientoNotifier(supabase);
});

class ServiciosMantenimientoNotifier extends SupabaseCrudNotifier<ServicioMantenimiento> {
  ServiciosMantenimientoNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'servicio_mantenimiento',
          primaryKey: 'id_servicio',
          fromJson: (json) => ServicioMantenimiento.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idServicio,
        );

  Future<void> fetchServiciosMantenimiento() => fetch();
  Future<void> addServicioMantenimiento(ServicioMantenimiento serv) => add(serv);
  Future<void> updateServicioMantenimiento(ServicioMantenimiento serv) => updateItem(serv);
  Future<void> deleteServicioMantenimiento(int id) => deleteItem(id);
}
