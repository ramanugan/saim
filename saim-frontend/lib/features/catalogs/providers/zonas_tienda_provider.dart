import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/zona_tienda.dart';

final zonasTiendaProvider = StateNotifierProvider<ZonasTiendaNotifier, AsyncValue<List<ZonaTienda>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return ZonasTiendaNotifier(supabase);
});

class ZonasTiendaNotifier extends SupabaseCrudNotifier<ZonaTienda> {
  ZonasTiendaNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'zona_tienda',
          primaryKey: 'id_zona_tienda',
          ascending: true,
          fromJson: (json) => ZonaTienda.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idZonaTienda,
        );

  Future<void> fetchZonasTienda() => fetch();
  Future<void> addZonaTienda(ZonaTienda item) => add(item);
  Future<void> updateZonaTienda(ZonaTienda item) => updateItem(item);
  Future<void> deleteZonaTienda(int idZonaTienda) => toggleStatus(idZonaTienda, true);
}
