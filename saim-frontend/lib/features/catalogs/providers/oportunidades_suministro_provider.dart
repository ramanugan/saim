import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/oportunidad_suministro.dart';

final helperSolicitudDetallesForOportunidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)');
  return List<Map<String, dynamic>>.from(response as List);
});

final helperCotizacionesForOportunidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('cotizacion')
      .select('id_cotizacion, numero_cotizacion');
  return List<Map<String, dynamic>>.from(response as List);
});

final oportunidadesSuministroProvider = StateNotifierProvider<OportunidadesSuministroNotifier, AsyncValue<List<OportunidadSuministro>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return OportunidadesSuministroNotifier(supabase);
});

class OportunidadesSuministroNotifier extends SupabaseCrudNotifier<OportunidadSuministro> {
  OportunidadesSuministroNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'oportunidad_suministro',
          primaryKey: 'id_oportunidad',
          ascending: false,
          fromJson: (json) => OportunidadSuministro.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idOportunidad,
        );

  Future<void> fetchOportunidades() => fetch();
  Future<void> addOportunidad(OportunidadSuministro item) => add(item);
  Future<void> updateOportunidad(OportunidadSuministro item) => updateItem(item);
}
