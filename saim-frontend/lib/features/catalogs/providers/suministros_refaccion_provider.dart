import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/suministro_refaccion.dart';

final helperSolicitudesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('solicitud_refaccion')
      .select('id_solicitud_refaccion, folio')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperProveedoresForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperAlmacenesForSuministroProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('almacen')
      .select('id_almacen, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
