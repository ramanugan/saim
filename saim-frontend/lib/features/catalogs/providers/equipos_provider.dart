import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/equipo.dart';

final equiposProvider = StateNotifierProvider<EquiposNotifier, AsyncValue<List<Equipo>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return EquiposNotifier(supabase);
});

class EquiposNotifier extends SupabaseCrudNotifier<Equipo> {
  EquiposNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'equipo',
          primaryKey: 'id_equipo',
          selectQuery: '*, tienda(nombre), tipo_equipo(nombre)',
          fromJson: (json) {
            final Map<String, dynamic> flatJson = Map<String, dynamic>.from(json);
            if (flatJson['tienda'] != null && flatJson['tienda'] is Map) {
              flatJson['nombre_tienda'] = flatJson['tienda']['nombre'];
            }
            if (flatJson['tipo_equipo'] != null && flatJson['tipo_equipo'] is Map) {
              flatJson['nombre_tipo_equipo'] = flatJson['tipo_equipo']['nombre'];
            }
            return Equipo.fromJson(flatJson);
          },
          toJson: (item) => item.toJson(),
          getId: (item) => item.idEquipo,
        );

  Future<void> fetchEquipos() => fetch();
  Future<void> addEquipo(Equipo equipo) => add(equipo);
  Future<void> updateEquipo(Equipo equipo) => updateItem(equipo);
  Future<void> deleteEquipo(int idEquipo) => deleteItem(idEquipo);
}
