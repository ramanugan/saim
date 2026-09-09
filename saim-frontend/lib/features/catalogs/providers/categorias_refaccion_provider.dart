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
  
  @override
  Future<void> add(CategoriaRefaccion item) async {
    try {
      final data = item.toJson();
      data.remove('id_categoria_refaccion');

      final inserted = await supabase
          .from('categoria_refaccion')
          .insert(data)
          .select()
          .single();

      final newId = inserted['id_categoria_refaccion'] as int;

      if (item.codigo == 'AUTO' || item.codigo.isEmpty) {
        final generatedCodigo = newId.toString().padLeft(3, '0');
        await supabase
            .from('categoria_refaccion')
            .update({'codigo': generatedCodigo})
            .eq('id_categoria_refaccion', newId);
        inserted['codigo'] = generatedCodigo;
      }

      state = AsyncValue.data([...state.value ?? [], CategoriaRefaccion.fromJson(inserted)]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> addCategoria(CategoriaRefaccion item) => add(item);
  Future<void> updateCategoria(CategoriaRefaccion item) => updateItem(item);
}
