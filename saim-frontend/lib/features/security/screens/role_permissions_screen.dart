import 'package:flutter/material.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../widgets/permissions_matrix.dart';

class RolePermissionsScreen extends StatelessWidget {
  RolePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Administración',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: PageHeading(
              eyebrow: 'Seguridad',
              title: 'Permisos de Rol',
              subtitle: 'Asignar y visualizar accesos a módulos por rol de usuario',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: PermissionsMatrix(),
            ),
          ),
        ],
      ),
    );
  }
}
