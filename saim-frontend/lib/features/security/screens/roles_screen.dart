import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/saim_button.dart';
import '../providers/roles_provider.dart';
import '../widgets/rol_form.dart';
import '../models/rol.dart';

class RolesScreen extends ConsumerStatefulWidget {
  const RolesScreen({super.key});

  @override
  ConsumerState<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends ConsumerState<RolesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(seguridadRolesProvider.notifier).fetchRoles());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showForm([Rol? rol]) {
    showDialog(
      context: context,
      builder: (ctx) => RolForm(rol: rol),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seguridadRolesProvider);

    return AppLayout(
      title: 'Roles',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: PageHeading(
                eyebrow: 'Seguridad',
                title: 'Roles',
                subtitle: 'Gestión de roles del sistema',
                actions: SaimButton(
                  text: 'Agregar Rol',
                  icon: Icons.add,
                  onPressed: () => _showForm(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por código, nombre o descripción...',
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
                    o.activo && (
                      o.codigo.toLowerCase().contains(_searchQuery) ||
                      o.nombre.toLowerCase().contains(_searchQuery) ||
                      o.descripcion.toLowerCase().contains(_searchQuery)
                    )
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No hay roles registrados.'));
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
                            DataColumn(label: Text('Código')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Descripción')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: filtered.map((rol) {
                            return DataRow(
                              cells: [
                                DataCell(Text(rol.idRol.toString())),
                                DataCell(Text(rol.codigo)),
                                DataCell(Text(rol.nombre)),
                                DataCell(Text(rol.descripcion)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showForm(rol),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Eliminar Rol'),
                                              content: const Text('¿Está seguro de eliminar este rol?'),
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
                                            ref.read(seguridadRolesProvider.notifier)
                                                .deleteRol(rol.idRol!);
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
