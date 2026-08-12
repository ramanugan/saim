import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../models/user_profile.dart';
import '../providers/users_provider.dart';
import 'assign_role_dialog.dart';
import '../../../core/theme/app_theme.dart';

class UsersTable extends ConsumerStatefulWidget {
  UsersTable({super.key});

  @override
  ConsumerState<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends ConsumerState<UsersTable> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Usuarios registrados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                    SizedBox(height: 4),
                    Text('Administración de perfiles y roles del sistema', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      height: 36,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar usuario...',
                          hintStyle: TextStyle(fontSize: 12, color: context.mutedTextColor),
                          prefixIcon: Icon(Icons.search, size: 16, color: context.mutedTextColor),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: context.borderColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.blue),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          usersAsync.when(
            data: (users) {
              final filteredUsers = _searchQuery.isEmpty 
                  ? users 
                  : users.where((u) => u.fullName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
              
              if (filteredUsers.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(users.isEmpty ? 'No hay usuarios registrados.' : 'No se encontraron resultados para "$_searchQuery".')
                  ),
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(context.backgroundColor),
                        columnSpacing: 24,
                        dataRowMaxHeight: 64,
                        columns: [
                          DataColumn(label: Text('NOMBRE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                          DataColumn(label: Text('EMAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                          DataColumn(label: Text('ROL ACTUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                          DataColumn(label: Text('ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                          DataColumn(label: Text('')),
                        ],
                        rows: filteredUsers.map((user) => _buildRow(context, ref, user)).toList(),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('Error: \$e', style: TextStyle(color: Colors.red))),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, UserProfile user) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: user.isActive ? AppColors.navy : AppColors.muted)),
              Text(user.id, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
            ],
          ),
        ),
        DataCell(Text(user.email ?? 'Sin correo', style: TextStyle(fontSize: 13, color: user.isActive ? AppColors.navy : AppColors.muted))),
        DataCell(Text(user.role?.name ?? 'Sin asignar', style: TextStyle(fontSize: 13, color: user.isActive ? AppColors.navy : AppColors.muted))),
        DataCell(
          Switch(
            value: user.isActive,
            activeColor: AppColors.blue,
            onChanged: (bool value) {
              ref.read(usersAdminProvider).toggleUserStatus(user.id, value);
            },
          ),
        ),
        DataCell(
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AssignRoleDialog(user: user),
              );
            },
            child: Text('Editar Perfil', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
