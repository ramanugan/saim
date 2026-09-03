import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/empleado.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final empleadosProvider = StateNotifierProvider<EmpleadosNotifier, AsyncValue<List<Empleado>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EmpleadosNotifier(supabase);
});

class EmpleadosNotifier extends SupabaseCrudNotifier<Empleado> {
  EmpleadosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'empleado',
          primaryKey: 'id_empleado',
          fromJson: (json) => Empleado.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idEmpleado,
        );

  Future<void> fetchEmpleados() => fetch();
  Future<void> addEmpleado(Empleado emp) => add(emp);
  Future<void> updateEmpleado(Empleado emp) => updateItem(emp);
  Future<void> deleteEmpleado(int id) => deleteItem(id);
}

final helperEmpleadosProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(empleadosProvider);
  
  return state.when(
    data: (empleados) {
      final actives = empleados.where((e) => e.activo).toList();
      return AsyncValue.data(
        actives.map((e) => {
          'id': e.idEmpleado,
          'nombre': '${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno ?? ''}'.trim(),
        }).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
