import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/permission.dart';

final allPermissionsProvider = FutureProvider<List<Permission>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  
  final response = await supabase
      .from('permissions')
      .select()
      .order('module')
      .order('action');
      
  return (response as List).map((json) => Permission.fromJson(json)).toList();
});

final rolePermissionsProvider = FutureProvider.family<List<int>, int>((ref, roleId) async {
  final supabase = ref.watch(supabaseClientProvider);
  
  // Obtenemos solo los permission_id asociados a este rol
  final response = await supabase
      .from('role_permissions')
      .select('permission_id')
      .eq('role_id', roleId);
      
  return (response as List).map((json) => json['permission_id'] as int).toList();
});
