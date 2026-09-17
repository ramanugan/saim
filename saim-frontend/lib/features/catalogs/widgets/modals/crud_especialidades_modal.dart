import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/especialidad.dart';
import '../../providers/especialidades_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudEspecialidadesModal extends ConsumerStatefulWidget {
  const CrudEspecialidadesModal({super.key});

  @override
  ConsumerState<CrudEspecialidadesModal> createState() => _CrudEspecialidadesModalState();
}

class _CrudEspecialidadesModalState extends ConsumerState<CrudEspecialidadesModal> {
  bool _isEditing = false;
  Especialidad? _selectedEspecialidad;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;

  bool _requiereCertificacion = false;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedEspecialidad?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedEspecialidad?.nombre ?? '');
    
    _requiereCertificacion = _selectedEspecialidad?.requiereCertificacion ?? false;
    _activo = _selectedEspecialidad?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _openForm([Especialidad? especialidad]) {
    setState(() {
      _selectedEspecialidad = especialidad;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedEspecialidad = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newEspecialidad = Especialidad(
      idEspecialidad: _selectedEspecialidad?.idEspecialidad,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      requiereCertificacion: _requiereCertificacion,
      activo: _activo,
    );

    try {
      if (_selectedEspecialidad == null) {
        await ref.read(especialidadesProvider.notifier).addEspecialidad(newEspecialidad);
      } else {
        await ref.read(especialidadesProvider.notifier).updateEspecialidad(newEspecialidad);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Especialidad especialidad) async {
    final action = especialidad.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${especialidad.activo ? 'Desactivar' : 'Activar'} Especialidad', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action esta especialidad?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(especialidad.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && especialidad.idEspecialidad != null) {
      try {
        await ref.read(especialidadesProvider.notifier).deleteEspecialidad(especialidad.idEspecialidad!);
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
                    _isEditing ? (_selectedEspecialidad == null ? 'Nueva Especialidad' : 'Editar Especialidad') : 'Gestión de Especialidades',
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
    final especialidadesAsync = ref.watch(especialidadesProvider);

    return especialidadesAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final especialidades = rawList.where((e) => e.activo).toList();
        if (especialidades.isEmpty) {
          return Center(
            child: Text('No hay especialidades registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('REQUIERE CERT.', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: especialidades.map((e) => DataRow(
            cells: [
              DataCell(Text(e.codigo, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.nombre, style: TextStyle(color: context.textColor))),
              DataCell(
                Icon(
                  e.requiereCertificacion ? Icons.check_circle : Icons.cancel,
                  color: e.requiereCertificacion ? AppColors.green : AppColors.red,
                  size: 20,
                ),
              ),
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
          )).toList(),
          searchableValues: especialidades.map((e) => '${e.codigo} ${e.nombre}').toList(),
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
              Text('Información de la Especialidad', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Código *', _codigoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildTextField('Nombre *', _nombreCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Requiere Certificación', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Switch(
                          value: _requiereCertificacion,
                          onChanged: (val) => setState(() => _requiereCertificacion = val),
                          activeColor: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activa en Sistema', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
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
}
