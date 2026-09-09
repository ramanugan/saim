import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/refaccion_compatibilidad.dart';
import 'refacciones_provider.dart';
import 'tipos_equipo_provider.dart';

final helperRefaccionesForCompatibilidadProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(refaccionesProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperTiposEquipoForCompatibilidadProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(tiposEquipoProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
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
