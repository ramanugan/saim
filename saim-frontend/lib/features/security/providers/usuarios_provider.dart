import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/usuario.dart';

final seguridadUsuariosProvider = StateNotifierProvider<SeguridadUsuariosNotifier, AsyncValue<List<Usuario>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return SeguridadUsuariosNotifier(supabase);
});

class SeguridadUsuariosNotifier extends SupabaseCrudNotifier<Usuario> {
  SeguridadUsuariosNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'usuario',
          primaryKey: 'id_usuario',
          ascending: true,
          orderBy: 'nombre_usuario',
          fromJson: (json) => Usuario.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idUsuario,
          selectQuery: '*, usuario_rol!fk_usuario_rol_id_usuario(*, rol(*))',
        );

  Future<void> fetchUsuarios() => fetch();

  Future<void> addUsuarioViaEdgeFunction(
    String email, 
    String password, 
    int? idEmpleado, 
    List<Map<String, dynamic>> roles,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'admin-create-user',
        body: {
          'email': email,
          'password': password,
          'id_empleado': idEmpleado,
          'roles': roles,
        },
      );

      if (response.status != 200) {
        throw Exception('Error al crear usuario: ${response.data}');
      }

      // Volver a cargar la lista después de crear
      await fetchUsuarios();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUsuario(Usuario item) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = item.toJson();
      data['actualizado_por'] = userIdInt;

      // El backend actualiza solo la tabla usuario (no cambia password ni auth)
      final response = await supabase
          .from('usuario')
          .update(data)
          .eq('id_usuario', item.idUsuario as Object)
          .select('*, usuario_rol!fk_usuario_rol_id_usuario(*, rol(*))')
          .single();

      final updatedItem = Usuario.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) => e.idUsuario == updatedItem.idUsuario ? updatedItem : e).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUsuario(int id) async {
    // Borrado logico
    try {
      final userIdInt = await getCurrentUserId();
      await supabase
          .from('usuario')
          .update({
            'estado_cuenta': 'INACTIVA',
            'actualizado_por': userIdInt,
          })
          .eq('id_usuario', id);

      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) {
          if (e.idUsuario == id) {
            return e.copyWith(estadoCuenta: 'INACTIVA');
          }
          return e;
        }).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
