import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/tipo_servicio.dart';

final tiposServicioProvider = StateNotifierProvider<TiposServicioNotifier, AsyncValue<List<TipoServicio>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return TiposServicioNotifier(supabase);
});

class TiposServicioNotifier extends SupabaseCrudNotifier<TipoServicio> {
  TiposServicioNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'tipo_servicio',
          primaryKey: 'id_tipo_servicio',
          ascending: true,
          orderBy: 'nombre',
          fromJson: (json) => TipoServicio.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idTipoServicio,
        );

  Future<void> fetchTiposServicio() => fetch();
  Future<void> addTipoServicio(TipoServicio item) => add(item);
  Future<void> updateTipoServicio(TipoServicio item) => updateItem(item);
}
