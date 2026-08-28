import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/refaccion.dart';
import 'categorias_refaccion_provider.dart';
import 'unidades_medida_provider.dart';

final helperCategoriasForRefaccionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final categoriasAsync = ref.watch(categoriasRefaccionProvider);
  return categoriasAsync.whenData((categorias) {
    return categorias
        .where((c) => c.activo)
        .map((c) => {
              'id_categoria_refaccion': c.idCategoriaRefaccion,
              'codigo': c.codigo,
              'nombre': c.nombre,
            })
        .toList();
  });
});

final helperUnidadesForRefaccionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final unidadesAsync = ref.watch(unidadesMedidaProvider);
  return unidadesAsync.whenData((unidades) {
    return unidades
        .where((u) => u.activo)
        .map((u) => {
              'id_unidad_medida': u.idUnidadMedida,
              'nombre': u.nombre,
              'simbolo': u.simbolo,
            })
        .toList();
  });
});

final refaccionesProvider = StateNotifierProvider<RefaccionesNotifier, AsyncValue<List<Refaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesNotifier(supabase);
});

class RefaccionesNotifier extends SupabaseCrudNotifier<Refaccion> {
  RefaccionesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'refaccion',
          primaryKey: 'id_refaccion',
          ascending: false,
          fromJson: (json) => Refaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idRefaccion,
        );

  Future<void> fetchRefacciones() => fetch();
  Future<void> addRefaccion(Refaccion item) => add(item);
  Future<void> updateRefaccion(Refaccion item) => updateItem(item);
}
