import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/users_provider.dart';
import '../providers/permissions_provider.dart';
import '../../../core/models/permission.dart';
import '../../../core/theme/app_theme.dart';

class PermissionsMatrix extends ConsumerStatefulWidget {
  PermissionsMatrix({super.key});

  @override
  ConsumerState<PermissionsMatrix> createState() => _PermissionsMatrixState();
}

class _PermissionsMatrixState extends ConsumerState<PermissionsMatrix> {
  int? _selectedRoleId;

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesProvider);
    final allPermissionsAsync = ref.watch(allPermissionsProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selector de Rol
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Selecciona un Rol:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: rolesAsync.when(
                    data: (roles) {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: _selectedRoleId,
                        hint: Text('Elige un rol para ver sus permisos'),
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role.id,
                            child: Text(role.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedRoleId = val;
                          });
                        },
                      );
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          
          // Matriz de Permisos
          Expanded(
            child: _selectedRoleId == null
                ? Center(
                    child: Text('Selecciona un rol para configurar sus accesos', style: TextStyle(color: context.mutedTextColor)),
                  )
                : allPermissionsAsync.when(
                    data: (permissions) {
                      // Agrupar permisos por módulo
                      final grouped = <String, List<Permission>>{};
                      for (var p in permissions) {
                        grouped.putIfAbsent(p.module, () => []).add(p);
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, index) {
                          final module = grouped.keys.elementAt(index);
                          final modulePermissions = grouped[module]!;
                          
                          return Card(
                            margin: EdgeInsets.only(bottom: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: context.borderColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: context.backgroundColor,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                  child: Text(
                                    module.toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor),
                                  ),
                                ),
                                Divider(height: 1, color: context.borderColor),
                                ...modulePermissions.map((permission) => _PermissionRow(
                                      roleId: _selectedRoleId!,
                                      permission: permission,
                                    )),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends ConsumerWidget {
  final int roleId;
  final Permission permission;

  const _PermissionRow({
    required this.roleId,
    required this.permission,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolePermissionsAsync = ref.watch(rolePermissionsProvider(roleId));

    return rolePermissionsAsync.when(
      data: (grantedIds) {
        final isGranted = grantedIds.contains(permission.id);
        
        return ListTile(
          title: Text(permission.action, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: permission.description != null ? Text(permission.description!, style: TextStyle(fontSize: 12, color: context.mutedTextColor)) : null,
          trailing: Switch(
            value: isGranted,
            activeColor: AppColors.blue,
            onChanged: (val) {
              ref.read(usersAdminProvider).toggleRolePermission(roleId, permission.id!, val);
            },
          ),
        );
      },
      loading: () => ListTile(title: Text('Cargando...')),
      error: (_, __) => ListTile(title: Text('Error al cargar')),
    );
  }
}
