import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/usuario.dart';

final usuarioRolProvider = StateNotifierProvider<UsuarioRolNotifier, AsyncValue<List<UsuarioRol>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return UsuarioRolNotifier(supabase);
});

class UsuarioRolNotifier extends SupabaseCrudNotifier<UsuarioRol> {
  UsuarioRolNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'usuario_rol',
          primaryKey: 'id_usuario_rol',
          ascending: true,
          orderBy: 'id_usuario_rol',
          fromJson: (json) => UsuarioRol.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idUsuarioRol,
        );

  Future<void> fetchUsuarioRoles() => fetch();

  Future<void> assignRol(int idUsuario, int idRol, {int? ambitoCliente, int? ambitoZona}) async {
    try {
      final userIdInt = await getCurrentUserId();
      final data = {
        'id_usuario': idUsuario,
        'id_rol': idRol,
        'activo': true,
        'ambito_cliente': ambitoCliente,
        'ambito_zona': ambitoZona,
        'creado_por': userIdInt,
        'actualizado_por': userIdInt,
        'fecha_inicio': DateTime.now().toIso8601String().split('T')[0],
      };

      final response = await supabase
          .from('usuario_rol')
          .insert(data)
          .select('*, rol(*)')
          .single();

      final newItem = UsuarioRol.fromJson(response);
      final currentList = state.value ?? [];
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> revokeRol(int idUsuarioRol) async {
    try {
      final userIdInt = await getCurrentUserId();
      await supabase
          .from('usuario_rol')
          .update({
            'activo': false,
            'fecha_fin': DateTime.now().toIso8601String().split('T')[0],
            'actualizado_por': userIdInt,
          })
          .eq('id_usuario_rol', idUsuarioRol);

      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) {
          if (e.idUsuarioRol == idUsuarioRol) {
            return UsuarioRol(
              idUsuarioRol: e.idUsuarioRol,
              idRol: e.idRol,
              rol: e.rol,
              activo: false,
              ambitoCliente: e.ambitoCliente,
              ambitoZona: e.ambitoZona,
            );
          }
          return e;
        }).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
