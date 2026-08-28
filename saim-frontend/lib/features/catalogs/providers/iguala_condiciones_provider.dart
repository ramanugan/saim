import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/iguala_condicion.dart';

// Helper providers for foreign key dropdowns
final helperIgualasProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala')
      .select('id_iguala, codigo_iguala')
      .eq('activo', true);
  // Deduplicate por id_iguala para evitar assertion de DropdownButton
  final seen = <int>{};
  return List<Map<String, dynamic>>.from(response as List)
      .where((item) => seen.add((item['id_iguala'] as num).toInt()))
      .toList();
});

final helperIgualaServiciosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala_servicio')
      .select('id_iguala_servicio, id_iguala, alcance_particular')
      .eq('activo', true);
  // Deduplicate por id_iguala_servicio
  final seen = <int>{};
  return List<Map<String, dynamic>>.from(response as List)
      .where((item) => seen.add((item['id_iguala_servicio'] as num).toInt()))
      .toList();
});


final helperPeriodicidadesProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return const AsyncValue.data([
    {'id_periodicidad': 1, 'nombre': 'MENSUAL'},
    {'id_periodicidad': 2, 'nombre': 'BIMESTRAL'},
    {'id_periodicidad': 3, 'nombre': 'TRIMESTRAL'},
    {'id_periodicidad': 4, 'nombre': 'SEMESTRAL'},
    {'id_periodicidad': 5, 'nombre': 'ANUAL'},
  ]);
});

final igualaCondicionesProvider = StateNotifierProvider<IgualaCondicionesNotifier, AsyncValue<List<IgualaCondicion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualaCondicionesNotifier(supabase);
});

class IgualaCondicionesNotifier extends SupabaseCrudNotifier<IgualaCondicion> {
  IgualaCondicionesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'iguala_condicion',
          primaryKey: 'id_iguala_condicion',
          ascending: false,
          fromJson: (json) => IgualaCondicion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idIgualaCondicion,
        );

  Future<void> fetchIgualaCondiciones() => fetch();
  Future<void> addIgualaCondicion(IgualaCondicion item) => add(item);
  Future<void> updateIgualaCondicion(IgualaCondicion item) => updateItem(item);
}
