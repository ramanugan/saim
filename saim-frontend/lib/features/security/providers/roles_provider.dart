import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/rol.dart';

final seguridadRolesProvider = StateNotifierProvider<SeguridadRolesNotifier, AsyncValue<List<Rol>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SeguridadRolesNotifier(supabase);
});

final helperSeguridadRolesProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(seguridadRolesProvider);

  return state.when(
    data: (list) => AsyncValue.data(
      list.map((item) => {
        'id': item.idRol,
        'nombre': item.nombre,
        'codigo': item.codigo,
        'activo': item.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class SeguridadRolesNotifier extends SupabaseCrudNotifier<Rol> {
  SeguridadRolesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'rol',
          primaryKey: 'id_rol',
          ascending: true,
          orderBy: 'nombre',
          fromJson: (json) => Rol.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idRol,
        );

  Future<void> fetchRoles() => fetch();

  Future<void> addRol(Rol item) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = item.toJson();
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;

      final response = await supabase
          .from('rol')
          .insert(data)
          .select()
          .single();

      final newItem = Rol.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRol(Rol item) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = item.toJson();
      data['actualizado_por'] = userIdInt;

      final response = await supabase
          .from('rol')
          .update(data)
          .eq('id_rol', item.idRol as Object)
          .select()
          .single();

      final updatedItem = Rol.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) => e.idRol == updatedItem.idRol ? updatedItem : e).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRol(int id) async {
    // Borrado logico
    try {
      final userIdInt = await getCurrentUserId();
      await supabase
          .from('rol')
          .update({
            'activo': false,
            'actualizado_por': userIdInt,
          })
          .eq('id_rol', id);

      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) {
          if (e.idRol == id) {
            return e.copyWith(activo: false);
          }
          return e;
        }).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
