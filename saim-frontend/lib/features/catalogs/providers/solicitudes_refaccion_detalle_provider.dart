import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/solicitud_refaccion_detalle.dart';

final helperSolicitudesForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion')
      .select('id_solicitud_refaccion, folio')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperEquiposForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('equipo')
      .select('id_equipo, codigo_activo_cliente, marca, modelo')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
