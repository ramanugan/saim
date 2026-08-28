import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/proveedor.dart';

final proveedoresProvider = StateNotifierProvider<ProveedoresNotifier, AsyncValue<List<Proveedor>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ProveedoresNotifier(supabase);
});

/// Helper para dropdowns — lista de proveedores activos como Map
final helperProveedoresProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(proveedoresProvider);
  return state.when(
    data: (list) {
      // Filtrar y deduplicar por id
      final seenIds = <int>{};
      final uniqueList = list.where((p) {
        if (p.idProveedor == null || !p.activo) return false;
        if (seenIds.contains(p.idProveedor)) return false;
        seenIds.add(p.idProveedor!);
        return true;
      }).toList();

      return AsyncValue.data(
        uniqueList.map((p) => {
          'id': p.idProveedor,
          'nombre': p.razonSocial,
          'rfc': p.rfc,
          'activo': p.activo,
        }).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class ProveedoresNotifier extends SupabaseCrudNotifier<Proveedor> {
  ProveedoresNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'proveedor',
          primaryKey: 'id_proveedor',
          orderBy: 'razon_social',
          fromJson: (json) => Proveedor.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idProveedor,
        );

  Future<void> fetchProveedores() => fetch();
  Future<void> addProveedor(Proveedor proveedor) => add(proveedor);
  Future<void> updateProveedor(Proveedor proveedor) => updateItem(proveedor);
  Future<void> deleteProveedor(int idProveedor) => deleteItem(idProveedor);
}
