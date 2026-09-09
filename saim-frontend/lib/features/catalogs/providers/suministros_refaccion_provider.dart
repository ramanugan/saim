import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/suministro_refaccion.dart';
import 'almacenes_provider.dart';
import 'solicitudes_refaccion_provider.dart';
import 'proveedores_provider.dart';

final helperSolicitudesForSuministroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(solicitudesRefaccionProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperProveedoresForSuministroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(proveedoresProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperAlmacenesForSuministroProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(almacenesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final suministrosRefaccionProvider = StateNotifierProvider<SuministrosRefaccionNotifier, AsyncValue<List<SuministroRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SuministrosRefaccionNotifier(supabase);
});

class SuministrosRefaccionNotifier extends SupabaseCrudNotifier<SuministroRefaccion> {
  SuministrosRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'suministro_refaccion',
          primaryKey: 'id_suministro',
          ascending: false,
          fromJson: (json) => SuministroRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idSuministro,
        );

  Future<void> fetchSuministros() => fetch();
  Future<void> addSuministro(SuministroRefaccion item) => add(item);
  Future<void> updateSuministro(SuministroRefaccion item) => updateItem(item);
}
