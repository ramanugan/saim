import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../models/user_profile.dart';
import 'permissions_provider.dart';

final rolesProvider = FutureProvider<List<Role>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  
  final response = await supabase
      .from('roles')
      .select()
      .order('id');
      
  return (response as List).map((json) => Role.fromJson(json)).toList();
});

final usersProvider = FutureProvider<List<UserProfile>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  
  // Notice we select the roles relationship to get the role name
  final response = await supabase
      .from('user_profiles')
      .select('*, roles(*)');
  final users = (response as List).map((json) => UserProfile.fromJson(json)).toList();
  
  users.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
  
  return users;
});

final usersAdminProvider = Provider<UsersAdminService>((ref) {
  return UsersAdminService(ref);
});

class UsersAdminService {
  final Ref _ref;
  
  UsersAdminService(this._ref);
  
  Future<void> updateUserProfile(String userId, int? roleId, String firstName, String lastName) async {
    final supabase = _ref.read(supabaseClientProvider);
    
    final Map<String, dynamic> updates = {
      'first_name': firstName,
      'last_name': lastName,
    };
    if (roleId != null) {
      updates['role_id'] = roleId;
    }
    
    await supabase.from('user_profiles').update(updates).eq('id', userId);
    
    // Invalidate the provider to refresh the list
    _ref.invalidate(usersProvider);
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    final supabase = _ref.read(supabaseClientProvider);
    
    await supabase.from('user_profiles').update({
      'is_active': isActive,
    }).eq('id', userId);
    
    _ref.invalidate(usersProvider);
  }

  Future<void> toggleRolePermission(int roleId, int permissionId, bool isGranted) async {
    final supabase = _ref.read(supabaseClientProvider);
    
    if (isGranted) {
      await supabase.from('role_permissions').insert({
        'role_id': roleId,
        'permission_id': permissionId,
      });
    } else {
      await supabase
          .from('role_permissions')
          .delete()
          .match({'role_id': roleId, 'permission_id': permissionId});
    }
    
    // Invalidate the provider to reflect changes in UI
    _ref.invalidate(rolePermissionsProvider(roleId));
  }
}
