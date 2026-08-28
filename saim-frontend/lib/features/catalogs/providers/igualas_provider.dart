import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/iguala.dart';
import 'tipos_servicio_provider.dart';

final helperTiendasForIgualaProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('tienda')
      .select('id_tienda, nombre, determinante')
      .eq('activo', true);
  return List<Map<String, dynamic>>.from(response as List);
});

final helperTiposServicioForIgualaProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final tiposAsync = ref.watch(tiposServicioProvider);
  return tiposAsync.whenData((tipos) => tipos
      .where((ts) => ts.activo)
      .map((ts) => {
            'id_tipo_servicio': ts.idTipoServicio,
            'nombre': ts.nombre,
            'codigo': ts.codigo,
          })
      .toList());
});

final igualasProvider = StateNotifierProvider<IgualasNotifier, AsyncValue<List<Iguala>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return IgualasNotifier(supabase);
});

class IgualasNotifier extends SupabaseCrudNotifier<Iguala> {
  IgualasNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'iguala',
          primaryKey: 'id_iguala',
          ascending: false,
          fromJson: (json) => Iguala.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idIguala,
        );

  Future<void> fetchIgualas() => fetch();
  Future<void> addIguala(Iguala item) => add(item);
  Future<void> updateIguala(Iguala item) => updateItem(item);
}
