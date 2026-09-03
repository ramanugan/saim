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
    data: (list) {
      final filteredList = list.where((z) => z.versionActiva == true).toList();
      return AsyncValue.data(
        filteredList.map((z) {
        final prefix = z.numeroContrato != null ? '${z.numeroContrato} | ' : '';
        return {
          'id': z.idZonaContrato,
          'nombre': '$prefix${z.codigo} - ${z.nombre}',
          'activo': z.activo,
        };
      }).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final helperZonasContratoUnicasProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(zonasContratoProvider);
  return state.when(
    data: (list) {
      final Map<String, Map<String, dynamic>> unicas = {};
      for (final z in list) {
        if (!unicas.containsKey(z.codigo)) {
          unicas[z.codigo!] = {
            'codigo': z.codigo,
            'nombre': z.nombre,
            'descripcion': z.descripcion ?? '',
          };
        }
      }
      return AsyncValue.data(unicas.values.toList());
    },
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
          selectQuery: '*, zona(codigo, nombre, descripcion), contrato_version(activo, contrato(numero_contrato))',
          fromJson: (json) => ZonaContrato.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idZonaContrato,
        );

  Future<void> fetchZonasContrato() => fetch();
  Future<void> addZonaContrato(ZonaContrato item) => add(item);
  Future<void> updateZonaContrato(ZonaContrato item) => updateItem(item);
  Future<void> deleteZonaContrato(int id) => deleteItem(id);
}
