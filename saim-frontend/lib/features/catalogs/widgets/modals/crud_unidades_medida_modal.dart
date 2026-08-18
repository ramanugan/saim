import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/unidad_medida.dart';
import '../../providers/unidades_medida_provider.dart';

class CrudUnidadesMedidaModal extends ConsumerStatefulWidget {
  const CrudUnidadesMedidaModal({super.key});

  @override
  ConsumerState<CrudUnidadesMedidaModal> createState() => _CrudUnidadesMedidaModalState();
}

class _CrudUnidadesMedidaModalState extends ConsumerState<CrudUnidadesMedidaModal> {
  bool _isEditing = false;
  UnidadMedida? _selectedItem;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _simboloCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedItem?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedItem?.nombre ?? '');
    _simboloCtrl = TextEditingController(text: _selectedItem?.simbolo ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _simboloCtrl.dispose();
    super.dispose();
  }

  void _openForm([UnidadMedida? item]) {
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

    final item = UnidadMedida(
      idUnidadMedida: _selectedItem?.idUnidadMedida,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      simbolo: _simboloCtrl.text.trim().isNotEmpty ? _simboloCtrl.text.trim() : null,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(unidadesMedidaProvider.notifier).addUnidadMedida(item);
      } else {
        await ref.read(unidadesMedidaProvider.notifier).updateUnidadMedida(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(UnidadMedida item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Unidad de Medida'),
        content: Text('¿Estás seguro de que deseas $action esta unidad de medida?'),
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

    if (confirm == true && item.idUnidadMedida != null) {
      try {
        await ref.read(unidadesMedidaProvider.notifier).toggleStatus(item.idUnidadMedida!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: isMobile ? size.width : 800,
        height: isMobile ? size.height : 700,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: context.borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unidades de Medida',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.textColor,
                    ),
                  ),
                  if (!_isEditing)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _openForm(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar Unidad de Medida'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.close, color: context.mutedTextColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.close, color: context.mutedTextColor),
                      onPressed: _closeForm,
                    ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: _isEditing ? _buildForm() : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final listAsync = ref.watch(unidadesMedidaProvider);

    return listAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text('No hay unidades de medida.', style: TextStyle(color: context.mutedTextColor)));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: context.mutedTextColor),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('CÓDIGO')),
                DataColumn(label: Text('NOMBRE')),
                DataColumn(label: Text('SÍMBOLO')),
                DataColumn(label: Text('ESTADO')),
                DataColumn(label: Text('ACCIONES')),
              ],
              rows: items.map((item) {
                return DataRow(
                  color: !item.activo ? WidgetStatePropertyAll(context.backgroundColor.withOpacity(0.5)) : null,
                  cells: [
                    DataCell(Text(item.idUnidadMedida.toString(), style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.codigo, style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.nombre, style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.simbolo ?? '-', style: TextStyle(color: context.textColor))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.activo ? AppColors.green.withOpacity(0.1) : AppColors.red.withOpacity(0.1),
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
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            color: AppColors.blue,
                            onPressed: () => _openForm(item),
                            tooltip: 'Editar',
                          ),
                          IconButton(
                            icon: Icon(item.activo ? Icons.block : Icons.check_circle, size: 20),
                            color: item.activo ? AppColors.red : AppColors.green,
                            onPressed: () => _toggleStatus(item),
                            tooltip: item.activo ? 'Desactivar' : 'Activar',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedItem == null ? 'Nueva Unidad de Medida' : 'Editar Unidad de Medida',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTextField('Código *', _codigoCtrl, required: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('Nombre *', _nombreCtrl, required: true)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTextField('Símbolo', _simboloCtrl)),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
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
