import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/inventario_refaccion.dart';
import 'refacciones_provider.dart';
import 'almacenes_provider.dart';

final helperAlmacenesForInventarioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(almacenesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperRefaccionesForInventarioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
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
