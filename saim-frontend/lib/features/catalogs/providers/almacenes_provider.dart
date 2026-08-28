import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/base_crud_notifier.dart';
import '../models/almacen.dart';

final almacenesProvider = StateNotifierProvider<AlmacenesNotifier, AsyncValue<List<Almacen>>>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return AlmacenesNotifier(supabase);
});

class AlmacenesNotifier extends SupabaseCrudNotifier<Almacen> {
  AlmacenesNotifier(SupabaseClient supabase)
      : super(
          supabase: supabase,
          tableName: 'almacen',
          primaryKey: 'id_almacen',
          ascending: false,
          fromJson: (json) => Almacen.fromJson(json),
          toJson: (item) => item.toJson(),
          getId: (item) => item.idAlmacen,
        );

  Future<void> fetchAlmacenes() => fetch();
  Future<void> addAlmacen(Almacen item) => add(item);
  Future<void> updateAlmacen(Almacen item) => updateItem(item);
}
