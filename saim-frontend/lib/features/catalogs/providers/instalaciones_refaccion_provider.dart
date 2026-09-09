import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/instalacion_refaccion.dart';
import 'equipos_provider.dart';
import 'solicitudes_refaccion_detalle_provider.dart';

final helperSolicitudDetallesForInstalacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(solicitudesRefaccionDetalleProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperOrdenesForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('orden_servicio')
      .select('id_orden_servicio, folio_orden')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperEquiposForInstalacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(equiposProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final instalacionesRefaccionProvider = StateNotifierProvider<InstalacionesRefaccionNotifier, AsyncValue<List<InstalacionRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return InstalacionesRefaccionNotifier(supabase);
});

class InstalacionesRefaccionNotifier extends SupabaseCrudNotifier<InstalacionRefaccion> {
  InstalacionesRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'instalacion_refaccion',
          primaryKey: 'id_instalacion',
          ascending: false,
          fromJson: (json) => InstalacionRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idInstalacion,
        );

  Future<void> fetchInstalaciones() => fetch();
  Future<void> addInstalacion(InstalacionRefaccion item) => add(item);
  Future<void> updateInstalacion(InstalacionRefaccion item) => updateItem(item);
}
