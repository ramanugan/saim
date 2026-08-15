import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/categoria_refaccion.dart';
import '../../providers/categorias_refaccion_provider.dart';

class CrudCategoriasRefaccionModal extends ConsumerStatefulWidget {
  const CrudCategoriasRefaccionModal({super.key});

  @override
  ConsumerState<CrudCategoriasRefaccionModal> createState() => _CrudCategoriasRefaccionModalState();
}

class _CrudCategoriasRefaccionModalState extends ConsumerState<CrudCategoriasRefaccionModal> {
  bool _isEditing = false;
  CategoriaRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _descripcionCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedItem?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedItem?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: _selectedItem?.descripcion ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _openForm([CategoriaRefaccion? item]) {
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

    final item = CategoriaRefaccion(
      idCategoriaRefaccion: _selectedItem?.idCategoriaRefaccion,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(categoriasRefaccionProvider.notifier).addCategoria(item);
      } else {
        await ref.read(categoriasRefaccionProvider.notifier).updateCategoria(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(CategoriaRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Categoría'),
        content: Text('¿Estás seguro de que deseas $action esta categoría?'),
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

    if (confirm == true && item.idCategoriaRefaccion != null) {
      try {
        await ref.read(categoriasRefaccionProvider.notifier).toggleStatus(item.idCategoriaRefaccion!, item.activo);
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
        constraints: const BoxConstraints(maxWidth: 800),
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
                        ? (_selectedItem == null ? 'Nueva Categoría' : 'Editar Categoría')
                        : 'Categorías de Refacción',
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
                          label: const Text('Agregar Categoría'),
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
    final listAsync = ref.watch(categoriasRefaccionProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de categorías.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('DESCRIPCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idCategoriaRefaccion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.codigo, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.descripcion ?? '-', style: TextStyle(color: context.textColor))),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Código *', _codigoCtrl, required: true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField('Nombre *', _nombreCtrl, required: true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Descripción', _descripcionCtrl),
            const SizedBox(height: 16),
            Row(
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
