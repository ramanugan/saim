import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/inventario_refaccion.dart';

final helperAlmacenesForInventarioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('almacen')
      .select('id_almacen, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperRefaccionesForInventarioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final inventariosRefaccionProvider = StateNotifierProvider<InventariosRefaccionNotifier, AsyncValue<List<InventarioRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return InventariosRefaccionNotifier(supabase);
});

class InventariosRefaccionNotifier extends SupabaseCrudNotifier<InventarioRefaccion> {
  InventariosRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'inventario_refaccion',
          primaryKey: 'id_inventario',
          ascending: false,
          fromJson: (json) => InventarioRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idInventario,
        );

  Future<void> fetchInventarios() => fetch();
  Future<void> addInventario(InventarioRefaccion item) => add(item);
  Future<void> updateInventario(InventarioRefaccion item) => updateItem(item);
}
