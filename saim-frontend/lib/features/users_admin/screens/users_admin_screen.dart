import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../widgets/users_table.dart';
import '../widgets/permissions_matrix.dart';

class UsersAdminScreen extends StatelessWidget {
  UsersAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Administración',
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: PageHeading(
                eyebrow: 'Seguridad',
                title: 'Usuarios y roles',
                subtitle: 'Gestiona los roles y accesos del sistema',
              ),
            ),
            TabBar(
              labelColor: AppColors.blue,
              unselectedLabelColor: AppColors.muted,
              indicatorColor: AppColors.blue,
              tabs: [
                Tab(text: 'Usuarios Registrados'),
                Tab(text: 'Matriz de Permisos por Rol'),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: TabBarView(
                  children: [
                    UsersTable(),
                    PermissionsMatrix(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

