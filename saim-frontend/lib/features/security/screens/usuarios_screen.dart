import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/saim_button.dart';
import '../providers/usuarios_provider.dart';
import '../widgets/usuario_form.dart';
import '../widgets/usuario_rol_form.dart';
import '../models/usuario.dart';

class UsuariosScreen extends ConsumerStatefulWidget {
  const UsuariosScreen({super.key});

  @override
  ConsumerState<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends ConsumerState<UsuariosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(seguridadUsuariosProvider.notifier).fetchUsuarios());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showForm([Usuario? usuario]) {
    showDialog(
      context: context,
      builder: (ctx) => UsuarioForm(usuario: usuario),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seguridadUsuariosProvider);

    return AppLayout(
      title: 'Usuarios',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: PageHeading(
                eyebrow: 'Seguridad',
                title: 'Usuarios',
                subtitle: 'Gestión de accesos y roles de usuario',
                actions: SaimButton(
                  text: 'Crear Usuario',
                  icon: Icons.person_add,
                  onPressed: () => _showForm(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, correo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: context.surfaceColor,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: state.when(
                data: (list) {
                  final filtered = list.where((o) => 
                    o.estadoCuenta != 'INACTIVA' && (
                      o.nombreUsuario.toLowerCase().contains(_searchQuery) ||
                      o.correo.toLowerCase().contains(_searchQuery)
                    )
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No hay usuarios registrados.'));
                  }

                  return Card(
                    color: context.surfaceColor,
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      side: BorderSide(color: context.surfaceColor.withOpacity(0.2)),
                    ),
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(context.backgroundColor),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Nombre de Usuario')),
                            DataColumn(label: Text('Correo')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Roles')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: filtered.map((usuario) {
                            final roleNames = usuario.roles
                                .where((r) => r.activo && r.rol != null)
                                .map((r) => r.rol!.nombre)
                                .join(', ');

                            return DataRow(
                              cells: [
                                DataCell(Text(usuario.idUsuario.toString())),
                                DataCell(Text(usuario.nombreUsuario)),
                                DataCell(Text(usuario.correo)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: usuario.estadoCuenta == 'ACTIVA' 
                                        ? Colors.green.withOpacity(0.1) 
                                        : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      usuario.estadoCuenta,
                                      style: TextStyle(
                                        color: usuario.estadoCuenta == 'ACTIVA' ? Colors.green : Colors.orange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(roleNames.isEmpty ? 'Sin roles' : roleNames)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.assignment_ind, size: 20),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => UsuarioRolForm(usuario: usuario),
                                          );
                                        },
                                        tooltip: 'Asignar Rol',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showForm(usuario),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Eliminar Usuario'),
                                              content: const Text('¿Está seguro de eliminar este usuario?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx, false),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx, true),
                                                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true && context.mounted) {
                                            ref.read(seguridadUsuariosProvider.notifier)
                                                .deleteUsuario(usuario.idUsuario!);
                                          }
                                        },
                                        tooltip: 'Eliminar',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
      ),
    );
  }
}
