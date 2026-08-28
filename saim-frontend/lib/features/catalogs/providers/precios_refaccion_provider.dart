import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/precio_refaccion.dart';

final helperRefaccionesForPrecioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperProveedoresForPrecioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final preciosRefaccionProvider = StateNotifierProvider<PreciosRefaccionNotifier, AsyncValue<List<PrecioRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return PreciosRefaccionNotifier(supabase);
});

class PreciosRefaccionNotifier extends SupabaseCrudNotifier<PrecioRefaccion> {
  PreciosRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'precio_refaccion',
          primaryKey: 'id_precio_refaccion',
          ascending: false,
          fromJson: (json) => PrecioRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idPrecioRefaccion,
        );

  Future<void> fetchPrecios() => fetch();
  Future<void> addPrecio(PrecioRefaccion item) => add(item);
  Future<void> updatePrecio(PrecioRefaccion item) => updateItem(item);
}
