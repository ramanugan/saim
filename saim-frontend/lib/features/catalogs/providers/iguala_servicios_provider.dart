import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/iguala_servicio.dart';

final helperIgualasForServicioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('iguala')
      .select('id_iguala, codigo_iguala')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposServicioProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tipo_servicio')
      .select('id_tipo_servicio, nombre')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
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
