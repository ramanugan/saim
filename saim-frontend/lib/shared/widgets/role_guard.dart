import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import 'saim_button.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class RoleGuard extends ConsumerWidget {
  final Widget child;
  final List<String> allowedRoles;

  RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return userProfileAsync.when(
      data: (profile) {
        if (profile == null) {
          return Scaffold(
            body: Center(child: Text('Cargando sesión...')),
          );
        }

        final userRole = profile.role?.name;
        if (userRole != null && allowedRoles.contains(userRole)) {
          return child;
        }

        // Access denied
        return Scaffold(
          backgroundColor: context.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 80, color: AppColors.red),
                SizedBox(height: 24),
                Text(
                  'Acceso Denegado',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: context.textColor),
                ),
                SizedBox(height: 8),
                Text(
                  'No tienes permisos para ver esta sección.',
                  style: TextStyle(color: context.mutedTextColor),
                ),
                SizedBox(height: 32),
                SaimButton(
                  text: 'Volver al Inicio',
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        body: Center(
          child: Text('Error al verificar permisos: \$e', style: TextStyle(color: AppColors.red)),
        ),
      ),
    );
  }
}
