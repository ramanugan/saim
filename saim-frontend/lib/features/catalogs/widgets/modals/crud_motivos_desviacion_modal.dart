import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/motivo_desviacion.dart';
import '../../providers/motivos_desviacion_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudMotivosDesviacionModal extends ConsumerStatefulWidget {
  const CrudMotivosDesviacionModal({super.key});

  @override
  ConsumerState<CrudMotivosDesviacionModal> createState() => _CrudMotivosDesviacionModalState();
}

class _CrudMotivosDesviacionModalState extends ConsumerState<CrudMotivosDesviacionModal> {
  bool _isEditing = false;
  MotivoDesviacion? _selectedMotivo;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;

  String _clasificacion = 'CLIENTE';
  bool _requiereEvidencia = false;
  bool _activo = true;

  final _clasificacionesList = ['CLIENTE', 'INTERNA', 'PROVEEDOR', 'EXTERNA'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedMotivo?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedMotivo?.nombre ?? '');

    _clasificacion = _selectedMotivo?.clasificacion ?? 'CLIENTE';
    if (!_clasificacionesList.contains(_clasificacion)) _clasificacion = _clasificacionesList[0];

    _requiereEvidencia = _selectedMotivo?.requiereEvidencia ?? false;
    _activo = _selectedMotivo?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _openForm([MotivoDesviacion? motivo]) {
    setState(() {
      _selectedMotivo = motivo;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedMotivo = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newMotivo = MotivoDesviacion(
      idMotivoDesviacion: _selectedMotivo?.idMotivoDesviacion,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      clasificacion: _clasificacion,
      requiereEvidencia: _requiereEvidencia,
      activo: _activo,
    );

    try {
      if (_selectedMotivo == null) {
        await ref.read(motivosDesviacionProvider.notifier).addMotivoDesviacion(newMotivo);
      } else {
        await ref.read(motivosDesviacionProvider.notifier).updateMotivoDesviacion(newMotivo);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(MotivoDesviacion motivo) async {
    final action = motivo.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${motivo.activo ? 'Desactivar' : 'Activar'} Motivo', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action este motivo de desviación?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(motivo.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && motivo.idMotivoDesviacion != null) {
      try {
        await ref.read(motivosDesviacionProvider.notifier).deleteMotivoDesviacion(motivo.idMotivoDesviacion!);
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
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 800),
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
                    _isEditing ? (_selectedMotivo == null ? 'Nuevo Motivo' : 'Editar Motivo') : 'Motivos de Desviación',
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
    final asyncData = ref.watch(motivosDesviacionProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay motivos registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('CLASIFICACIÓN', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('EVIDENCIA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            return DataRow(
              cells: [
                DataCell(Text(e.codigo, style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold))),
                DataCell(Text(e.nombre, style: TextStyle(color: context.textColor))),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.clasificacion,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Icon(
                  e.requiereEvidencia ? Icons.check_circle : Icons.cancel,
                  color: e.requiereEvidencia ? AppColors.green : AppColors.red,
                  size: 20,
                )),
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                      onPressed: () => _openForm(e),
                    ),
                    IconButton(
                      icon: Icon(e.activo ? Icons.block : Icons.check_circle_outline, color: e.activo ? AppColors.red : AppColors.green, size: 20),
                      onPressed: () => _toggleStatus(e),
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
          searchableValues: lista.map((e) => '${e.codigo} ${e.nombre} ${e.clasificacion}').toList(),
        );
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
              Row(
                children: [
                  Expanded(child: _buildTextField('Código *', _codigoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Clasificación *', _clasificacion, _clasificacionesList, (val) => setState(() => _clasificacion = val as String))),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField('Nombre *', _nombreCtrl, required: true),
              SizedBox(height: 16),
              _buildSwitch('Requiere Evidencia', _requiereEvidencia, (val) => setState(() => _requiereEvidencia = val)),
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

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        Container(
          width: 200,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value ? 'Sí' : 'No', style: TextStyle(color: context.textColor)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
