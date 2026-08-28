import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/solicitud_refaccion.dart';
import 'igualas_provider.dart';

final helperIgualasForSolicitudProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final igualasAsync = ref.watch(igualasProvider);
  return igualasAsync.whenData((igualas) => igualas
      .where((i) => i.activo)
      .map((i) => {
            'id_iguala': i.idIguala,
            'codigo_iguala': i.codigoIguala,
          })
      .toList());
});

final helperOrdenesForSolicitudProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('orden_servicio')
      .select('id_orden_servicio, folio_orden')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperUsuariosForSolicitudProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('usuario')
      .select('id_usuario, nombre_usuario')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final solicitudesRefaccionProvider = StateNotifierProvider<SolicitudesRefaccionNotifier, AsyncValue<List<SolicitudRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SolicitudesRefaccionNotifier(supabase);
});

class SolicitudesRefaccionNotifier extends SupabaseCrudNotifier<SolicitudRefaccion> {
  SolicitudesRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'solicitud_refaccion',
          primaryKey: 'id_solicitud_refaccion',
          ascending: false,
          fromJson: (json) => SolicitudRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idSolicitudRefaccion,
        );

  Future<void> fetchSolicitudes() => fetch();
  Future<void> addSolicitud(SolicitudRefaccion item) => add(item);
  Future<void> updateSolicitud(SolicitudRefaccion item) => updateItem(item);
}
