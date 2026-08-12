import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/users_admin/models/user_profile.dart';
import '../models/permission.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final session = authState.value?.session;
  
  if (session == null) return null;
  
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase
      .from('user_profiles')
      .select('*, roles(*)')
      .eq('id', session.user.id)
      .maybeSingle();
      
  if (response == null) return null;
  
  final profile = UserProfile.fromJson(response);
  
  if (!profile.isActive) {
    // Si está inactivo, forzar el cierre de sesión
    Future.microtask(() => ref.read(authServiceProvider).signOut());
    return null;
  }
  
  return profile;
});

final myPermissionsProvider = FutureProvider<List<Permission>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final session = authState.value?.session;
  
  if (session == null) return [];
  
  final supabase = ref.read(supabaseClientProvider);
  final response = await supabase.from('my_permissions').select();
  
  return (response as List).map((json) => Permission.fromJson(json)).toList();
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
      final profileRes = await _supabase.from('user_profiles').select('is_active').eq('id', res.user!.id).maybeSingle();
      if (profileRes != null && profileRes['is_active'] == false) {
        await _supabase.auth.signOut();
        throw Exception('Tu cuenta ha sido deshabilitada por el administrador.');
      }
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
