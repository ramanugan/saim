import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/categoria_refaccion.dart';

final categoriasRefaccionProvider = StateNotifierProvider<CategoriasRefaccionNotifier, AsyncValue<List<CategoriaRefaccion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return CategoriasRefaccionNotifier(supabase);
});

class CategoriasRefaccionNotifier extends SupabaseCrudNotifier<CategoriaRefaccion> {
  CategoriasRefaccionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'categoria_refaccion',
          primaryKey: 'id_categoria_refaccion',
          ascending: false,
          fromJson: (json) => CategoriaRefaccion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idCategoriaRefaccion,
        );

  Future<void> fetchCategorias() => fetch();
  Future<void> addCategoria(CategoriaRefaccion item) => add(item);
  Future<void> updateCategoria(CategoriaRefaccion item) => updateItem(item);
}
