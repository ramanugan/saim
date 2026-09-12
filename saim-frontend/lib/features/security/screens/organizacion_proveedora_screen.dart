import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/saim_button.dart';
import '../providers/organizacion_proveedora_provider.dart';
import '../widgets/organizacion_proveedora_form.dart';
import '../models/organizacion_proveedora.dart';

class OrganizacionProveedoraScreen extends ConsumerStatefulWidget {
  const OrganizacionProveedoraScreen({super.key});

  @override
  ConsumerState<OrganizacionProveedoraScreen> createState() => _OrganizacionProveedoraScreenState();
}

class _OrganizacionProveedoraScreenState extends ConsumerState<OrganizacionProveedoraScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(organizacionProveedoraProvider.notifier).fetchOrganizaciones());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showForm([OrganizacionProveedora? organizacion]) {
    showDialog(
      context: context,
      builder: (ctx) => OrganizacionProveedoraForm(organizacion: organizacion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizacionProveedoraProvider);

    return AppLayout(
      title: 'Organización Proveedora',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: PageHeading(
                eyebrow: 'Seguridad',
                title: 'Organización Proveedora',
                subtitle: 'Gestión de organizaciones proveedoras (RFC, Razón social)',
                actions: SaimButton(
                  text: 'Agregar Organización',
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
                hintText: 'Buscar por razón social, nombre o RFC...',
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
                      o.razonSocial.toLowerCase().contains(_searchQuery) ||
                      (o.nombreComercial?.toLowerCase().contains(_searchQuery) ?? false) ||
                      o.rfc.toLowerCase().contains(_searchQuery)
                    )
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No hay organizaciones registradas.'));
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
                            DataColumn(label: Text('Razón Social')),
                            DataColumn(label: Text('Nombre Comercial')),
                            DataColumn(label: Text('RFC')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: filtered.map((org) {
                            return DataRow(
                              cells: [
                                DataCell(Text(org.idOrganizacion.toString())),
                                DataCell(Text(org.razonSocial)),
                                DataCell(Text(org.nombreComercial ?? '-')),
                                DataCell(Text(org.rfc)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showForm(org),
                                        tooltip: 'Editar',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Eliminar Organización'),
                                              content: const Text('¿Está seguro de eliminar este registro?'),
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
                                            ref.read(organizacionProveedoraProvider.notifier)
                                                .deleteOrganizacion(org.idOrganizacion!);
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
