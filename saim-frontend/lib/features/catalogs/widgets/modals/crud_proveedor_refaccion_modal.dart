import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/proveedor_refaccion.dart';
import '../../providers/proveedores_refaccion_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudProveedorRefaccionModal extends ConsumerStatefulWidget {
  const CrudProveedorRefaccionModal({super.key});

  @override
  ConsumerState<CrudProveedorRefaccionModal> createState() => _CrudProveedorRefaccionModalState();
}

class _CrudProveedorRefaccionModalState extends ConsumerState<CrudProveedorRefaccionModal> {
  bool _isEditing = false;
  ProveedorRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedProveedorId;
  int? _selectedRefaccionId;
  late TextEditingController _codigoProveedorCtrl;
  late TextEditingController _plazoEntregaCtrl;
  bool _esPreferente = false;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedProveedorId = _selectedItem?.idProveedor;
    _selectedRefaccionId = _selectedItem?.idRefaccion;
    _codigoProveedorCtrl = TextEditingController(text: _selectedItem?.codigoProveedor ?? '');
    _plazoEntregaCtrl = TextEditingController(text: _selectedItem?.plazoEntregaDias?.toString() ?? '');
    _esPreferente = _selectedItem?.esPreferente ?? false;
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoProveedorCtrl.dispose();
    _plazoEntregaCtrl.dispose();
    super.dispose();
  }

  void _openForm([ProveedorRefaccion? item]) {
    setState(() {
      _selectedItem = item;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedItem = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProveedorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un Proveedor')));
      return;
    }
    if (_selectedRefaccionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Refacción')));
      return;
    }

    final item = ProveedorRefaccion(
      idProveedorRefaccion: _selectedItem?.idProveedorRefaccion,
      idProveedor: _selectedProveedorId!,
      idRefaccion: _selectedRefaccionId!,
      codigoProveedor: _codigoProveedorCtrl.text.trim().isEmpty ? null : _codigoProveedorCtrl.text.trim(),
      plazoEntregaDias: int.tryParse(_plazoEntregaCtrl.text),
      esPreferente: _esPreferente,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(proveedoresRefaccionProvider.notifier).addProveedorRefaccion(item);
      } else {
        await ref.read(proveedoresRefaccionProvider.notifier).updateProveedorRefaccion(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(ProveedorRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Oferta de Proveedor'),
        content: Text('¿Estás seguro de que deseas $action esta oferta de refacción?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(item.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && item.idProveedorRefaccion != null) {
      try {
        await ref.read(proveedoresRefaccionProvider.notifier).toggleStatus(item.idProveedorRefaccion!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        constraints: const BoxConstraints(maxWidth: 900),
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
                    _isEditing
                        ? (_selectedItem == null ? 'Asociar Refacción a Proveedor' : 'Editar Asociación')
                        : 'Proveedores de Refacciones',
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
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Asociar Refacción'),
                        ),
                      const SizedBox(width: 16),
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
    final listAsync = ref.watch(proveedoresRefaccionProvider);
    final proveedoresAsync = ref.watch(helperProveedoresForProvRefProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForProvRefProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay refacciones asociadas a proveedores.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final proveedoresMap = {
          for (var item in proveedoresAsync.value ?? [])
            item['id_proveedor'] as int: item['razon_social'] as String
        };

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PROVEEDOR', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓD. PROVEEDOR', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PLAZO ENTREGA (DÍAS)', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PREFERENTE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idProveedorRefaccion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(proveedoresMap[item.idProveedor] ?? 'Prov ID: ${item.idProveedor}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(refaccionesMap[item.idRefaccion] ?? 'Ref ID: ${item.idRefaccion}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.codigoProveedor ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.plazoEntregaDias?.toString() ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Icon(
                      item.esPreferente ? Icons.star : Icons.star_border,
                      color: item.esPreferente ? Colors.amber : context.mutedTextColor,
                      size: 20,
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: item.activo ? AppColors.green : AppColors.red,
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
                        icon: const Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(item),
                      ),
                      IconButton(
                        icon: Icon(item.activo ? Icons.block : Icons.check_circle_outline, color: item.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(item),
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
    final proveedoresAsync = ref.watch(helperProveedoresForProvRefProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForProvRefProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Proveedor & Refaccion
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Proveedor *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedProveedorId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (proveedoresAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_proveedor'] as int,
                              child: Text(item['razon_social'] as String, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedProveedorId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedRefaccionId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (refaccionesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final code = item['codigo_interno'] as String;
                            final desc = item['descripcion_homologada'] as String;
                            return DropdownMenuItem<int>(
                              value: item['id_refaccion'] as int,
                              child: Text('[$code] $desc', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedRefaccionId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Código Proveedor & Plazo Entrega
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Código de Referencia del Proveedor', _codigoProveedorCtrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Plazo de Entrega (Días)', _plazoEntregaCtrl, keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Es Preferente & Activo
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Proveedor Preferente para esta refacción', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _esPreferente,
                          onChanged: (val) {
                            setState(() {
                              _esPreferente = val;
                            });
                          },
                          activeColor: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _activo,
                          onChanged: (val) {
                            setState(() {
                              _activo = val;
                            });
                          },
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save & Cancel buttons
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
          ),
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
