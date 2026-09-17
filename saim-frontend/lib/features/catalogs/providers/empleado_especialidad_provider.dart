import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/empleado_especialidad.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final empleadosEspecialidadesProvider = StateNotifierProvider<EmpleadosEspecialidadesNotifier, AsyncValue<List<EmpleadoEspecialidad>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EmpleadosEspecialidadesNotifier(supabase);
});

class EmpleadosEspecialidadesNotifier extends SupabaseCrudNotifier<EmpleadoEspecialidad> {
  EmpleadosEspecialidadesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'empleado_especialidad',
          primaryKey: 'id_empleado_especialidad',
          fromJson: (json) => EmpleadoEspecialidad.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idEmpleadoEspecialidad,
        );

  Future<void> fetchEmpleadosEspecialidades() => fetch();
  Future<void> addEmpleadoEspecialidad(EmpleadoEspecialidad empEsp) => add(empEsp);
  Future<void> updateEmpleadoEspecialidad(EmpleadoEspecialidad empEsp) => updateItem(empEsp);
  Future<void> deleteEmpleadoEspecialidad(int id) => deleteItem(id);
}
