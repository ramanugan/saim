import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/cliente.dart';
import '../../providers/clientes_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudClientesModal extends ConsumerStatefulWidget {
  const CrudClientesModal({super.key});

  @override
  ConsumerState<CrudClientesModal> createState() => _CrudClientesModalState();
}

class _CrudClientesModalState extends ConsumerState<CrudClientesModal> {
  bool _isEditing = false;
  Cliente? _selectedCliente;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoCtrl;
  late TextEditingController _razonSocialCtrl;
  late TextEditingController _nombreComercialCtrl;
  late TextEditingController _rfcCtrl;
  late TextEditingController _correoCtrl;
  late TextEditingController _telefonoCtrl;
  String _estatus = 'Activo';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedCliente?.codigo ?? '');
    _razonSocialCtrl = TextEditingController(text: _selectedCliente?.razonSocial ?? '');
    _nombreComercialCtrl = TextEditingController(text: _selectedCliente?.nombreComercial ?? '');
    _rfcCtrl = TextEditingController(text: _selectedCliente?.rfc ?? '');
    _correoCtrl = TextEditingController(text: _selectedCliente?.correoContacto ?? '');
    _telefonoCtrl = TextEditingController(text: _selectedCliente?.telefonoContacto ?? '');
    _estatus = _selectedCliente?.estatus ?? 'Activo';
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _razonSocialCtrl.dispose();
    _nombreComercialCtrl.dispose();
    _rfcCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _openForm([Cliente? cliente]) {
    setState(() {
      _selectedCliente = cliente;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedCliente = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newCliente = Cliente(
      idCliente: _selectedCliente?.idCliente,
      codigo: _codigoCtrl.text.trim(),
      razonSocial: _razonSocialCtrl.text.trim(),
      nombreComercial: _nombreComercialCtrl.text.trim(),
      rfc: _rfcCtrl.text.trim(),
      correoContacto: _correoCtrl.text.trim(),
      telefonoContacto: _telefonoCtrl.text.trim(),
      estatus: _estatus,
      activo: _selectedCliente?.activo ?? true,
    );

    try {
      if (_selectedCliente == null) {
        await ref.read(clientesProvider.notifier).addCliente(newCliente);
      } else {
        await ref.read(clientesProvider.notifier).updateCliente(newCliente);
      }
      _closeForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteCliente(Cliente cliente) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Cliente'),
        content: Text('¿Estás seguro de eliminar a ${cliente.nombreComercial}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ref.read(clientesProvider.notifier).deleteCliente(cliente.idCliente!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxWidth: 1000),
        height: 600,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? (_selectedCliente == null ? 'Nuevo Cliente' : 'Editar Cliente') : 'Gestión de Clientes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.textColor),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Expanded(
              child: _isEditing ? _buildForm() : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final clientesAsync = ref.watch(clientesProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: Icon(Icons.add, size: 18),
                label: Text('Agregar Cliente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: clientesAsync.when(
            data: (clientes) {
              final activeClientes = clientes.where((c) => c.activo).toList();
              if (activeClientes.isEmpty) {
                return Center(child: Text('No hay clientes registrados', style: TextStyle(color: context.mutedTextColor)));
              }
              return ModalDataTable(dataTable: DataTable(
                    columns: const [
                      DataColumn(label: Text('CÓDIGO')),
                      DataColumn(label: Text('NOMBRE COMERCIAL')),
                      DataColumn(label: Text('RAZÓN SOCIAL')),
                      DataColumn(label: Text('ESTATUS')),
                      DataColumn(label: Text('ACCIONES')),
                    ],
                    rows: activeClientes.map((c) => DataRow(
                      cells: [
                        DataCell(Text(c.codigo)),
                        DataCell(Text(c.nombreComercial)),
                        DataCell(Text(c.razonSocial)),
                        DataCell(Text(c.estatus)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 18, color: AppColors.blue),
                              onPressed: () => _openForm(c),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _deleteCliente(c),
                            ),
                          ],
                        )),
                      ]
                    )).toList(),
                  ));
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _codigoCtrl,
              decoration: InputDecoration(labelText: 'Código (Obligatorio)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _razonSocialCtrl,
              decoration: InputDecoration(labelText: 'Razón Social (Obligatorio)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nombreComercialCtrl,
              decoration: InputDecoration(labelText: 'Nombre Comercial (Obligatorio)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _rfcCtrl,
              decoration: InputDecoration(labelText: 'RFC', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _correoCtrl,
              decoration: InputDecoration(labelText: 'Correo de Contacto', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _telefonoCtrl,
              decoration: InputDecoration(labelText: 'Teléfono de Contacto', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _estatus,
              decoration: InputDecoration(labelText: 'Estatus', border: OutlineInputBorder()),
              items: ['Activo', 'Inactivo', 'Prospecto'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _estatus = v!),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _closeForm, child: Text('Cancelar')),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
