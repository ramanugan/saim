import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/security/models/usuario.dart';
import '../models/permission.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final currentUserProfileProvider = FutureProvider<Usuario?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final session = authState.value?.session;
  
  if (session == null) return null;
  
  final supabase = ref.read(supabaseClientProvider);
  try {
    final response = await supabase
        .from('usuario')
        .select('*, usuario_rol!fk_usuario_rol_id_usuario(*, rol(*))')
        .eq('auth_id', session.user.id)
        .maybeSingle();
        
    if (response == null) return null;
    
    final profile = Usuario.fromJson(response);
    
    if (profile.estadoCuenta != 'ACTIVA') {
      // Si está inactivo, forzar el cierre de sesión
      Future.microtask(() => ref.read(authServiceProvider).signOut());
      return null;
    }
    
    return profile;
  } catch (e) {
    if (e is PostgrestException && (e.code == 'PGRST301' || e.message.contains('JWT') || e.code == '401' || e.code == '403')) {
      Future.microtask(() => ref.read(authServiceProvider).signOut());
      return null;
    }
    if (e is AuthException) {
      Future.microtask(() => ref.read(authServiceProvider).signOut());
      return null;
    }
    rethrow;
  }
});

final myPermissionsProvider = FutureProvider<List<Permission>>((ref) async {
  final profile = await ref.watch(currentUserProfileProvider.future);
  if (profile == null) return [];
  
  final roleIds = profile.roles.where((r) => r.activo && r.rol != null).map((r) => r.idRol).toList();
  if (roleIds.isEmpty) return [];
  
  final supabase = ref.read(supabaseClientProvider);
  try {
    final response = await supabase
        .from('rol_permiso')
        .select('permissions(id, module, action, description)')
        .inFilter('id_rol', roleIds);
        
    final Map<int, Permission> uniquePermissions = {};
    for (var row in response) {
      if (row['permissions'] != null) {
        final perm = Permission.fromJson(row['permissions']);
        if (perm.id != null) {
          uniquePermissions[perm.id!] = perm;
        }
      }
    }
    return uniquePermissions.values.toList();
  } catch (e) {
    return [];
  }
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthService(supabase);
});

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  User? get currentUser => _supabase.auth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(email: email, password: password);
    if (res.user != null) {
      final profileRes = await _supabase.from('usuario').select('estado_cuenta').eq('auth_id', res.user!.id).maybeSingle();
      if (profileRes != null && profileRes['estado_cuenta'] != 'ACTIVA') {
        await _supabase.auth.signOut();
        throw Exception('Tu cuenta ha sido deshabilitada por el administrador.');
      }
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
