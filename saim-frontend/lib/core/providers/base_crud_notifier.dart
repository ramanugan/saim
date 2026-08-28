import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_provider.dart';

abstract class SupabaseCrudNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final SupabaseClient supabase;
  final String tableName;
  final String primaryKey;
  final String? orderBy;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final Object? Function(T) getId;

  final String selectQuery;
  final bool ascending;

  SupabaseCrudNotifier({
    required this.supabase,
    required this.tableName,
    required this.primaryKey,
    this.orderBy,
    required this.fromJson,
    required this.toJson,
    required this.getId,
    this.selectQuery = '*',
    this.ascending = true,
  }) : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    try {
      state = const AsyncValue.loading();
      final response = await supabase
          .from(tableName)
          .select(selectQuery)
          .order(orderBy ?? primaryKey, ascending: ascending);
          
      final list = (response as List).map((json) => fromJson(json)).toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> getCurrentUserId() async {
    final user = supabase.auth.currentUser;
    if (user == null || user.email == null) return 1; // Fallback
    try {
      final response = await supabase
          .from('usuario')
          .select('id_usuario')
          .eq('correo', user.email!)
          .maybeSingle();
      if (response != null) {
        return response['id_usuario'] as int;
      }
    } catch (_) {}
    return 1; // Fallback
  }

  Future<void> add(T item) async {
    try {
      final currentList = state.value ?? [];
      final userIdInt = await getCurrentUserId();

      final data = toJson(item);
      data['creado_por'] = userIdInt;
      data['actualizado_por'] = userIdInt;
      
      final response = await supabase
          .from(tableName)
          .insert(data)
          .select()
          .single();
          
      final newItem = fromJson(response);
      state = AsyncValue.data([newItem, ...currentList]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItem(T item) async {
    try {
      final itemId = getId(item);
      if (itemId == null) return;
      
      final currentList = state.value ?? [];
      final userIdInt = await getCurrentUserId();

      final data = toJson(item);
      data.remove(primaryKey); // <-- Prevención del error GENERATED ALWAYS
      data['actualizado_por'] = userIdInt;
      data['actualizado_en'] = DateTime.now().toIso8601String();
      
      final response = await supabase
          .from(tableName)
          .update(data)
          .eq(primaryKey, itemId)
          .select()
          .single();
          
      final updatedItem = fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => getId(x) == itemId ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(Object id) async {
    try {
      final currentList = state.value ?? [];
      // Soft delete
      await supabase
          .from(tableName)
          .update({'activo': false})
          .eq(primaryKey, id);
          
      state = AsyncValue.data(
        currentList.where((x) => getId(x) != id).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> toggleStatus(Object id, bool currentStatus) async {
    try {
      final currentList = state.value ?? [];
      final userIdInt = await getCurrentUserId();
      
      final response = await supabase
          .from(tableName)
          .update({
            'activo': !currentStatus,
            'actualizado_por': userIdInt,
          })
          .eq(primaryKey, id)
          .select()
          .single();

      final updatedItem = fromJson(response);
      state = AsyncValue.data(
        currentList.map((x) => getId(x) == id ? updatedItem : x).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
