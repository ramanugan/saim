import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/motivo_desviacion.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final helperMotivosDesviacionProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(motivosDesviacionProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final motivosDesviacionProvider = StateNotifierProvider<MotivosDesviacionNotifier, AsyncValue<List<MotivoDesviacion>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return MotivosDesviacionNotifier(supabase);
});

class MotivosDesviacionNotifier extends SupabaseCrudNotifier<MotivoDesviacion> {
  MotivosDesviacionNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'motivo_desviacion',
          primaryKey: 'id_motivo_desviacion',
          fromJson: (json) => MotivoDesviacion.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idMotivoDesviacion,
        );

  Future<void> fetchMotivosDesviacion() => fetch();
  Future<void> addMotivoDesviacion(MotivoDesviacion item) => add(item);
  Future<void> updateMotivoDesviacion(MotivoDesviacion item) => updateItem(item);
  Future<void> deleteMotivoDesviacion(int id) => deleteItem(id);
}
