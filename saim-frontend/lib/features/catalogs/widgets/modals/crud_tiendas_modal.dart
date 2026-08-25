import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/tienda.dart';
import '../../providers/tiendas_provider.dart';
import '../../providers/clientes_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudTiendasModal extends ConsumerStatefulWidget {
  const CrudTiendasModal({super.key});

  @override
  ConsumerState<CrudTiendasModal> createState() => _CrudTiendasModalState();
}

class _CrudTiendasModalState extends ConsumerState<CrudTiendasModal> {
  bool _isEditing = false;
  Tienda? _selectedTienda;

  final _formKey = GlobalKey<FormState>();
  int? _idCliente;
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _codigoPostalCtrl;
  late TextEditingController _correoCtrl;
  late TextEditingController _telefonoCtrl;
  String _estatus = 'Activo';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idCliente = _selectedTienda?.idCliente;
    _codigoCtrl = TextEditingController(text: _selectedTienda?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedTienda?.nombre ?? '');
    _direccionCtrl = TextEditingController(text: _selectedTienda?.direccion ?? '');
    _codigoPostalCtrl = TextEditingController(text: _selectedTienda?.codigoPostal ?? '');
    _correoCtrl = TextEditingController(text: _selectedTienda?.correoContacto ?? '');
    _telefonoCtrl = TextEditingController(text: _selectedTienda?.telefonoContacto ?? '');
    _estatus = _selectedTienda?.estatus ?? 'Activo';
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _codigoPostalCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _openForm([Tienda? tienda]) {
    setState(() {
      _selectedTienda = tienda;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedTienda = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCliente == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Selecciona un Cliente')));
      return;
    }

    final newTienda = Tienda(
      idTienda: _selectedTienda?.idTienda,
      idCliente: _idCliente!,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
      codigoPostal: _codigoPostalCtrl.text.trim().isEmpty ? null : _codigoPostalCtrl.text.trim(),
      correoContacto: _correoCtrl.text.trim().isEmpty ? null : _correoCtrl.text.trim(),
      telefonoContacto: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      estatus: _estatus,
      activo: _selectedTienda?.activo ?? true,
    );

    try {
      if (_selectedTienda == null) {
        await ref.read(tiendasProvider.notifier).addTienda(newTienda);
      } else {
        await ref.read(tiendasProvider.notifier).updateTienda(newTienda);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteTienda(Tienda tienda) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Tienda'),
        content: Text('¿Estás seguro de eliminar la tienda "${tienda.nombre}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true && tienda.idTienda != null) {
      try {
        await ref.read(tiendasProvider.notifier).deleteTienda(tienda.idTienda!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 1050),
        height: 620,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing
                        ? (_selectedTienda == null ? 'Nueva Tienda' : 'Editar Tienda')
                        : 'Gestión de Tiendas',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.borderColor),
            Expanded(
              child: _isEditing ? _buildForm() : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final tiendasAsync = ref.watch(tiendasProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar Tienda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tiendasAsync.when(
            data: (tiendas) {
              final active = tiendas.where((t) => t.activo).toList();
              if (active.isEmpty) {
                return Center(
                  child: Text('No hay tiendas registradas.',
                      style: TextStyle(color: context.mutedTextColor)),
                );
              }
              return ModalDataTable(dataTable: DataTable(
                    columns: [
                      DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
                    ],
                    rows: active.map((t) => DataRow(
                      cells: [
                        DataCell(Text(t.codigo, style: TextStyle(color: context.textColor))),
                        DataCell(Text(t.nombre, style: TextStyle(color: context.textColor))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: t.estatus == 'Activo'
                                ? AppColors.green.withOpacity(0.15)
                                : AppColors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            t.estatus,
                            style: TextStyle(
                              color: t.estatus == 'Activo' ? AppColors.green : AppColors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                              onPressed: () => _openForm(t),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                              onPressed: () => _deleteTienda(t),
                            ),
                          ],
                        )),
                      ],
                    )).toList(),
                  ));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
                child: Text('Error: $e',
                    style: TextStyle(color: AppColors.red))),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final clientesAsync = ref.watch(clientesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cliente selector
            clientesAsync.when(
              data: (clientes) {
                final active = clientes.where((c) => c.activo).toList();
                return DropdownButtonFormField<int>(
                  value: _idCliente,
                  decoration: InputDecoration(
                    labelText: 'Cliente *',
                    labelStyle: TextStyle(color: context.textColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: context.backgroundColor,
                  ),
                  dropdownColor: context.surfaceColor,
                  style: TextStyle(color: context.textColor),
                  items: active
                      .map((c) => DropdownMenuItem(
                            value: c.idCliente,
                            child: Text('${c.codigo} — ${c.nombreComercial}',
                                style: TextStyle(color: context.textColor)),
                          ))
                      .toList(),
                  validator: (v) => v == null ? 'Selecciona un cliente' : null,
                  onChanged: (v) => setState(() => _idCliente = v),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error cargando clientes: $e'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTextField('Código *', _codigoCtrl, required: true, maxLength: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _buildTextField('Nombre *', _nombreCtrl, required: true, maxLength: 160),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Dirección', _direccionCtrl, maxLength: 300),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTextField('Código Postal', _codigoPostalCtrl, maxLength: 10),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildTextField('Correo de Contacto', _correoCtrl, maxLength: 200),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildTextField('Teléfono de Contacto', _telefonoCtrl, maxLength: 30),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _estatus,
              decoration: InputDecoration(
                labelText: 'Estatus',
                labelStyle: TextStyle(color: context.textColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: context.backgroundColor,
              ),
              dropdownColor: context.surfaceColor,
              style: TextStyle(color: context.textColor),
              items: ['Activo', 'Inactivo', 'Temporal']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _estatus = v!),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _closeForm,
                  style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool required = false, int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          validator:
              required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
