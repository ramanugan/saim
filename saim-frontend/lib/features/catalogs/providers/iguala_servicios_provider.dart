import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/iguala_servicio.dart';
import 'tipos_servicio_provider.dart';
import 'igualas_provider.dart';

final helperIgualasForServicioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(igualasProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final helperTiposServicioProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final asyncData = ref.watch(tiposServicioProvider);
  return asyncData.whenData((items) => items
      .map((e) => e.toJson())
      .where((json) => json.containsKey('activo') ? json['activo'] == true : true)
      .toList());
});

final igualaServiciosProvider = StateNotifierProvider<IgualaServiciosNotifier, AsyncValue<List<IgualaServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualaServiciosNotifier(supabase);
});

class IgualaServiciosNotifier extends SupabaseCrudNotifier<IgualaServicio> {
  IgualaServiciosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'iguala_servicio',
          primaryKey: 'id_iguala_servicio',
          ascending: false,
          fromJson: (json) => IgualaServicio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idIgualaServicio,
        );

  Future<void> fetchIgualaServicios() => fetch();
  Future<void> addIgualaServicio(IgualaServicio item) => add(item);
  Future<void> updateIgualaServicio(IgualaServicio item) => updateItem(item);
}
