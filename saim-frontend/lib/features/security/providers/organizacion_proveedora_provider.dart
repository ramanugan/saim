import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/organizacion_proveedora.dart';

final organizacionProveedoraProvider = StateNotifierProvider<OrganizacionProveedoraNotifier, AsyncValue<List<OrganizacionProveedora>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return OrganizacionProveedoraNotifier(supabase);
});

final helperOrganizacionProveedoraProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final state = ref.watch(organizacionProveedoraProvider);

  return state.when(
    data: (list) => AsyncValue.data(
      list.map((item) => {
        'id': item.idOrganizacion,
        'nombre': item.razonSocial,
        'rfc': item.rfc,
        'activo': item.activo,
      }).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

class OrganizacionProveedoraNotifier extends SupabaseCrudNotifier<OrganizacionProveedora> {
  OrganizacionProveedoraNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'organizacion_proveedora',
          primaryKey: 'id_organizacion',
          ascending: true,
          orderBy: 'razon_social',
          fromJson: (json) => OrganizacionProveedora.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idOrganizacion,
        );

  Future<void> fetchOrganizaciones() => fetch();

  Future<void> addOrganizacion(OrganizacionProveedora item) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = item.toJson();
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;

      final response = await supabase
          .from('organizacion_proveedora')
          .insert(data)
          .select()
          .single();

      final newItem = OrganizacionProveedora.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrganizacion(OrganizacionProveedora item) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = item.toJson();
      data['actualizado_por'] = userIdInt;

      final response = await supabase
          .from('organizacion_proveedora')
          .update(data)
          .eq('id_organizacion', item.idOrganizacion as Object)
          .select()
          .single();

      final updatedItem = OrganizacionProveedora.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) => e.idOrganizacion == updatedItem.idOrganizacion ? updatedItem : e).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrganizacion(int id) async {
    // Borrado logico
    try {
      final userIdInt = await getCurrentUserId();
      await supabase
          .from('organizacion_proveedora')
          .update({
            'activo': false,
            'actualizado_por': userIdInt,
          })
          .eq('id_organizacion', id);

      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) {
          if (e.idOrganizacion == id) {
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
