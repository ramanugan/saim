import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';

class RequirePermission extends ConsumerWidget {
  final String module;
  final String action;
  final Widget child;
  final Widget fallback;

  RequirePermission({
    super.key,
    required this.module,
    required this.action,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsAsync = ref.watch(myPermissionsProvider);

    return permissionsAsync.when(
      data: (permissions) {
        final hasPermission = permissions.any((p) => p.matches(module, action));
        
        if (hasPermission) {
          return child;
        } else {
          return fallback;
        }
      },
      loading: () => SizedBox.shrink(), // O un pequeño loading si lo prefieres
      error: (_, __) => fallback,
    );
  }
}
