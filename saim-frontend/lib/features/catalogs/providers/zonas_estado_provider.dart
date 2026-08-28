import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/zona_estado.dart';

final zonasEstadoProvider = StateNotifierProvider<ZonasEstadoNotifier, AsyncValue<List<ZonaEstado>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasEstadoNotifier(supabase);
});

class ZonasEstadoNotifier extends SupabaseCrudNotifier<ZonaEstado> {
  ZonasEstadoNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'zona_estado',
          primaryKey: 'id_zona_estado',
          ascending: true,
          fromJson: (json) => ZonaEstado.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idZonaEstado,
        );

  Future<void> fetchZonasEstado() => fetch();
  Future<void> addZonaEstado(ZonaEstado item) => add(item);
  Future<void> updateZonaEstado(ZonaEstado item) => updateItem(item);
  Future<void> deleteZonaEstado(int idZonaEstado) => toggleStatus(idZonaEstado, true);
}
