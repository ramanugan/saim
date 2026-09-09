import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/suministro_refaccion_detalle.dart';
import 'suministros_refaccion_provider.dart';
import 'solicitudes_refaccion_detalle_provider.dart';

final helperSuministrosForDetalleProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(suministrosRefaccionProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperSolicitudDetallesForSuministroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(solicitudesRefaccionDetalleProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
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
