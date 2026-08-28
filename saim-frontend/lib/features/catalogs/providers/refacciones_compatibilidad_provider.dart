import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/refaccion_compatibilidad.dart';

final helperRefaccionesForCompatibilidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('refaccion')
      .select('id_refaccion, codigo_interno, descripcion_homologada')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposEquipoForCompatibilidadProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tipo_equipo')
      .select('id_tipo_equipo, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final refaccionesCompatibilidadProvider = StateNotifierProvider<RefaccionesCompatibilidadNotifier, AsyncValue<List<RefaccionCompatibilidad>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return RefaccionesCompatibilidadNotifier(supabase);
});

class RefaccionesCompatibilidadNotifier extends SupabaseCrudNotifier<RefaccionCompatibilidad> {
  RefaccionesCompatibilidadNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'refaccion_compatibilidad',
          primaryKey: 'id_compatibilidad',
          ascending: false,
          fromJson: (json) => RefaccionCompatibilidad.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idCompatibilidad,
        );

  Future<void> fetchCompatibilidades() => fetch();
  Future<void> addCompatibilidad(RefaccionCompatibilidad item) => add(item);
  Future<void> updateCompatibilidad(RefaccionCompatibilidad item) => updateItem(item);
}
