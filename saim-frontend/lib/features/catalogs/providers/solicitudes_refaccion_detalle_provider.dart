import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/solicitud_refaccion_detalle.dart';
import 'refacciones_provider.dart';
import 'equipos_provider.dart';
import 'solicitudes_refaccion_provider.dart';

final helperSolicitudesForDetalleProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(solicitudesRefaccionProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperRefaccionesForDetalleProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperEquiposForDetalleProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(equiposProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final solicitudesRefaccionDetalleProvider = StateNotifierProvider<SolicitudesRefaccionDetalleNotifier, AsyncValue<List<SolicitudRefaccionDetalle>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SolicitudesRefaccionDetalleNotifier(supabase);
});

class SolicitudesRefaccionDetalleNotifier extends SupabaseCrudNotifier<SolicitudRefaccionDetalle> {
  SolicitudesRefaccionDetalleNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'solicitud_refaccion_detalle',
          primaryKey: 'id_solicitud_refaccion_detalle',
          ascending: false,
          fromJson: (json) => SolicitudRefaccionDetalle.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idSolicitudRefaccionDetalle,
        );

  Future<void> fetchDetalles() => fetch();
  Future<void> addDetalle(SolicitudRefaccionDetalle item) => add(item);
  Future<void> updateDetalle(SolicitudRefaccionDetalle item) => updateItem(item);
}
