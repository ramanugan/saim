import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/suministro_refaccion_detalle.dart';

final helperSuministrosForDetalleProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('suministro_refaccion')
      .select('id_suministro, documento_referencia, fuente_suministro')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperSolicitudDetallesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion_detalle')
      .select('id_solicitud_refaccion_detalle, cantidad_solicitada, refaccion(codigo_interno, descripcion_homologada)');
  return List<Map<String, dynamic>>.from(response as List);
});

final suministrosRefaccionDetalleProvider = StateNotifierProvider<SuministrosRefaccionDetalleNotifier, AsyncValue<List<SuministroRefaccionDetalle>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SuministrosRefaccionDetalleNotifier(supabase);
});

class SuministrosRefaccionDetalleNotifier extends SupabaseCrudNotifier<SuministroRefaccionDetalle> {
  SuministrosRefaccionDetalleNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'suministro_refaccion_detalle',
          primaryKey: 'id_suministro_detalle',
          ascending: false,
          fromJson: (json) => SuministroRefaccionDetalle.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idSuministroDetalle,
        );

  Future<void> fetchDetalles() => fetch();
  Future<void> addDetalle(SuministroRefaccionDetalle item) => add(item);
  Future<void> updateDetalle(SuministroRefaccionDetalle item) => updateItem(item);
}
