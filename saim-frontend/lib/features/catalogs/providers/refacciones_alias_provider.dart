import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/refaccion_alias.dart';

final helperRefaccionesForAliasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperUsuariosForAliasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('usuario')
      .select('id_usuario, nombre_usuario')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final refaccionesAliasProvider = StateNotifierProvider<RefaccionesAliasNotifier, AsyncValue<List<RefaccionAlias>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesAliasNotifier(supabase);
});

class RefaccionesAliasNotifier extends SupabaseCrudNotifier<RefaccionAlias> {
  RefaccionesAliasNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'refaccion_alias',
          primaryKey: 'id_refaccion_alias',
          ascending: false,
          fromJson: (json) => RefaccionAlias.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idRefaccionAlias,
        );

  Future<void> fetchAliases() => fetch();
  Future<void> addAlias(RefaccionAlias item) => add(item);
  Future<void> updateAlias(RefaccionAlias item) => updateItem(item);
}
