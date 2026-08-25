import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/tipo_servicio.dart';
import '../../providers/tipos_servicio_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudTiposServicioModal extends ConsumerStatefulWidget {
  const CrudTiposServicioModal({super.key});

  @override
  ConsumerState<CrudTiposServicioModal> createState() => _CrudTiposServicioModalState();
}

class _CrudTiposServicioModalState extends ConsumerState<CrudTiposServicioModal> {
  bool _isEditing = false;
  TipoServicio? _selectedTipoServicio;

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
    _codigoCtrl = TextEditingController(text: _selectedTipoServicio?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedTipoServicio?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: _selectedTipoServicio?.descripcion ?? '');
    _activo = _selectedTipoServicio?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _openForm([TipoServicio? tipoServicio]) {
    setState(() {
      _selectedTipoServicio = tipoServicio;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedTipoServicio = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newTipo = TipoServicio(
      idTipoServicio: _selectedTipoServicio?.idTipoServicio,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedTipoServicio == null) {
        await ref.read(tiposServicioProvider.notifier).addTipoServicio(newTipo);
      } else {
        await ref.read(tiposServicioProvider.notifier).updateTipoServicio(newTipo);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(TipoServicio tipoServicio) async {
    final action = tipoServicio.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${tipoServicio.activo ? 'Desactivar' : 'Activar'} Tipo de Servicio'),
        content: Text('¿Estás seguro de que deseas $action este tipo de servicio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(tipoServicio.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && tipoServicio.idTipoServicio != null) {
      try {
        await ref.read(tiposServicioProvider.notifier).toggleStatus(tipoServicio.idTipoServicio!, tipoServicio.activo);
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
        constraints: BoxConstraints(maxWidth: 800),
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
                    _isEditing ? (_selectedTipoServicio == null ? 'Nuevo Tipo de Servicio' : 'Editar Tipo de Servicio') : 'Gestión de Tipos de Servicio',
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
    final tiposAsync = ref.watch(tiposServicioProvider);

    return tiposAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (tipos) {
        if (tipos.isEmpty) {
          return Center(
            child: Text('No hay tipos de servicio registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: tipos.map((t) => DataRow(
                cells: [
                  DataCell(Text(t.codigo, style: TextStyle(color: context.textColor))),
                  DataCell(Text(t.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: t.activo ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        t.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: t.activo ? AppColors.green : AppColors.red,
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
                        onPressed: () => _openForm(t),
                      ),
                      IconButton(
                        icon: Icon(t.activo ? Icons.block : Icons.check_circle_outline, color: t.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(t),
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
              _buildTextField('Código *', _codigoCtrl, required: true),
              SizedBox(height: 16),
              _buildTextField('Nombre *', _nombreCtrl, required: true),
              SizedBox(height: 16),
              _buildTextField('Descripción', _descripcionCtrl),
              SizedBox(height: 24),
              Row(
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
}
