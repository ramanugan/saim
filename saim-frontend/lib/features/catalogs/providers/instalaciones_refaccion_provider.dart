import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/instalacion_refaccion.dart';

final helperSolicitudDetallesForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperOrdenesForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('orden_servicio')
      .select('id_orden_servicio, folio_orden')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperEquiposForInstalacionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('equipo')
      .select('id_equipo, codigo_activo_cliente, marca, modelo')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
