import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../models/zona.dart';

import '../../../../core/providers/base_crud_notifier.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final zonasProvider = StateNotifierProvider<ZonasNotifier, AsyncValue<List<Zona>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasNotifier(supabase);
});

class ZonasNotifier extends SupabaseCrudNotifier<Zona> {
  ZonasNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'zona',
          primaryKey: 'id_zona',
          fromJson: (json) => Zona.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idZona,
        );

  Future<void> fetchZonas() => fetch();
  Future<void> addZona(Zona zona) => add(zona);
  Future<void> updateZona(Zona zona) => updateItem(zona);
  Future<void> deleteZona(int idZona) => deleteItem(idZona);
}

final helperZonasProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final zonasState = ref.watch(zonasProvider);
  
  return zonasState.when(
    data: (zonas) {
      final activeZonas = zonas.where((z) => z.activo).toList();
      return AsyncValue.data(
        activeZonas.map((z) => {
          'id': z.idZona,
          'nombre': '${z.codigo} - ${z.nombre}',
        }).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
