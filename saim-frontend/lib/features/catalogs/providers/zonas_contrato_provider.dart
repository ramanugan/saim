import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/zona_contrato.dart';

final zonasContratoProvider = StateNotifierProvider<ZonasContratoNotifier, AsyncValue<List<ZonaContrato>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasContratoNotifier(supabase);
});

final helperZonasContratoProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(zonasContratoProvider);
  return state.when(
    data: (list) => AsyncValue.data(
      list.map((z) => {
        'id': z.idZonaContrato,
        'nombre': '${z.codigo} - ${z.nombre}',
        'activo': z.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class ZonasContratoNotifier extends SupabaseCrudNotifier<ZonaContrato> {
  ZonasContratoNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'zona_contrato',
          primaryKey: 'id_zona_contrato',
          fromJson: (json) => ZonaContrato.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idZonaContrato,
        );

  Future<void> fetchZonasContrato() => fetch();
  Future<void> addZonaContrato(ZonaContrato item) => add(item);
  Future<void> updateZonaContrato(ZonaContrato item) => updateItem(item);
  Future<void> deleteZonaContrato(int id) => deleteItem(id);
}
