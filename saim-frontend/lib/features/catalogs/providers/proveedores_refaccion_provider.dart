import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/proveedor_refaccion.dart';
import 'refacciones_provider.dart';
import 'proveedores_provider.dart';

final helperProveedoresForProvRefProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(proveedoresProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperRefaccionesForProvRefProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final proveedoresRefaccionProvider = StateNotifierProvider<ProveedoresRefaccionNotifier, AsyncValue<List<ProveedorRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ProveedoresRefaccionNotifier(supabase);
});

class ProveedoresRefaccionNotifier extends SupabaseCrudNotifier<ProveedorRefaccion> {
  ProveedoresRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'proveedor_refaccion',
          primaryKey: 'id_proveedor_refaccion',
          ascending: false,
          fromJson: (json) => ProveedorRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idProveedorRefaccion,
        );

  Future<void> fetchProveedoresRefaccion() => fetch();
  Future<void> addProveedorRefaccion(ProveedorRefaccion item) => add(item);
  Future<void> updateProveedorRefaccion(ProveedorRefaccion item) => updateItem(item);
}
