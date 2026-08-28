import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/proveedor.dart';
import '../../providers/proveedores_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudProveedoresModal extends ConsumerStatefulWidget {
  const CrudProveedoresModal({super.key});

  @override
  ConsumerState<CrudProveedoresModal> createState() => _CrudProveedoresModalState();
}

class _CrudProveedoresModalState extends ConsumerState<CrudProveedoresModal> {
  bool _isEditing = false;
  Proveedor? _selectedProveedor;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _razonSocialCtrl;
  late TextEditingController _rfcCtrl;
  late TextEditingController _contactoCtrl;
  late TextEditingController _correoCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _tipoProveedorCtrl;

  String _estatus = 'ACTIVO';
  bool _activo = true;

  final _estatusOptions = ['ACTIVO', 'INACTIVO'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _razonSocialCtrl = TextEditingController(text: _selectedProveedor?.razonSocial ?? '');
    _rfcCtrl = TextEditingController(text: _selectedProveedor?.rfc ?? '');
    _contactoCtrl = TextEditingController(text: _selectedProveedor?.contacto ?? '');
    _correoCtrl = TextEditingController(text: _selectedProveedor?.correo ?? '');
    _telefonoCtrl = TextEditingController(text: _selectedProveedor?.telefono ?? '');
    _tipoProveedorCtrl = TextEditingController(text: _selectedProveedor?.tipoProveedor ?? '');
    
    _estatus = _selectedProveedor?.estatus ?? 'ACTIVO';
    _activo = _selectedProveedor?.activo ?? true;
  }

  @override
  void dispose() {
    _razonSocialCtrl.dispose();
    _rfcCtrl.dispose();
    _contactoCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    _tipoProveedorCtrl.dispose();
    super.dispose();
  }

  void _openForm([Proveedor? proveedor]) {
    setState(() {
      _selectedProveedor = proveedor;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedProveedor = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newProveedor = Proveedor(
      idProveedor: _selectedProveedor?.idProveedor,
      razonSocial: _razonSocialCtrl.text.trim(),
      rfc: _rfcCtrl.text.trim().isEmpty ? null : _rfcCtrl.text.trim(),
      contacto: _contactoCtrl.text.trim().isEmpty ? null : _contactoCtrl.text.trim(),
      correo: _correoCtrl.text.trim().isEmpty ? null : _correoCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      tipoProveedor: _tipoProveedorCtrl.text.trim(),
      estatus: _estatus,
      activo: _activo,
    );

    try {
      if (_selectedProveedor == null) {
        await ref.read(proveedoresProvider.notifier).addProveedor(newProveedor);
      } else {
        await ref.read(proveedoresProvider.notifier).updateProveedor(newProveedor);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Proveedor proveedor) async {
    final action = proveedor.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${proveedor.activo ? 'Desactivar' : 'Activar'} Proveedor'),
        content: Text('¿Estás seguro de que deseas $action este proveedor?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(proveedor.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && proveedor.idProveedor != null) {
      try {
        await ref.read(proveedoresProvider.notifier).deleteProveedor(proveedor.idProveedor!);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxWidth: 900),
        height: MediaQuery.of(context).size.height * 0.9,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? (_selectedProveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor') : 'Gestión de Proveedores',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  Row(
                    children: [
                      if (!_isEditing)
                        ElevatedButton.icon(
                          onPressed: () => _openForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Agregar'),
                        ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.close, color: context.mutedTextColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(height: 1, color: context.borderColor),
            Expanded(
              child: _isEditing ? _buildForm() : _buildTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    final proveedoresAsync = ref.watch(proveedoresProvider);

    return proveedoresAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (proveedores) {
        if (proveedores.isEmpty) {
          return Center(
            child: Text('No hay proveedores registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('RAZÓN SOCIAL', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('RFC', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CONTACTO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: proveedores.map((p) => DataRow(
                cells: [
                  DataCell(Text(p.razonSocial, style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.rfc ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.tipoProveedor, style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.contacto ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.estatus, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.activo ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        p.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: p.activo ? AppColors.green : AppColors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(p),
                      ),
                      IconButton(
                        icon: Icon(p.activo ? Icons.block : Icons.check_circle_outline, color: p.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(p),
                      ),
                    ],
                  )),
                ],
              )).toList(),
            ));
      },
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información General', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildTextField('Razón Social *', _razonSocialCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: _buildTextField('RFC', _rfcCtrl)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Tipo de Proveedor *', _tipoProveedorCtrl, required: true)),
                ],
              ),
              SizedBox(height: 32),
              Text('Contacto', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Contacto (Nombre)', _contactoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Correo Electrónico', _correoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Teléfono', _telefonoCtrl)),
                ],
              ),
              SizedBox(height: 32),
              Text('Estado y Operación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLocalDropdown('Estatus *', _estatus, _estatusOptions, (v) => setState(() => _estatus = v.toString()))),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Switch(
                          value: _activo,
                          onChanged: (val) => setState(() => _activo = val),
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _closeForm,
                    style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Guardar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }

  Widget _buildLocalDropdown(String label, String value, List<String> items, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          dropdownColor: context.surfaceColor,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          items: items.map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
