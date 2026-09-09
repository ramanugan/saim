import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/precio_refaccion.dart';
import 'refacciones_provider.dart';
import 'proveedores_provider.dart';

final helperRefaccionesForPrecioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperProveedoresForPrecioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(proveedoresProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
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
