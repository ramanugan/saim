import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/proveedor_refaccion.dart';

final helperProveedoresForProvRefProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('proveedor')
      .select('id_proveedor, razon_social')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForProvRefProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
