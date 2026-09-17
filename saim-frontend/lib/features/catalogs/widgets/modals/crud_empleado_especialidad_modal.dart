import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/empleado_especialidad.dart';
import '../../providers/empleado_especialidad_provider.dart';
import '../../providers/empleados_provider.dart';
import '../../providers/especialidades_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudEmpleadoEspecialidadModal extends ConsumerStatefulWidget {
  const CrudEmpleadoEspecialidadModal({super.key});

  @override
  ConsumerState<CrudEmpleadoEspecialidadModal> createState() => _CrudEmpleadoEspecialidadModalState();
}

class _CrudEmpleadoEspecialidadModalState extends ConsumerState<CrudEmpleadoEspecialidadModal> {
  bool _isEditing = false;
  EmpleadoEspecialidad? _selectedRelacion;

  final _formKey = GlobalKey<FormState>();
  int? _idEmpleado;
  int? _idEspecialidad;
  late TextEditingController _nivelCtrl;
  late TextEditingController _numeroCertificadoCtrl;
  late TextEditingController _vigenciaHastaCtrl;

  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idEmpleado = _selectedRelacion?.idEmpleado == 0 ? null : _selectedRelacion?.idEmpleado;
    _idEspecialidad = _selectedRelacion?.idEspecialidad == 0 ? null : _selectedRelacion?.idEspecialidad;
    
    _nivelCtrl = TextEditingController(text: _selectedRelacion?.nivel ?? '');
    _numeroCertificadoCtrl = TextEditingController(text: _selectedRelacion?.numeroCertificado ?? '');
    _vigenciaHastaCtrl = TextEditingController(text: _selectedRelacion?.vigenciaHasta ?? '');
    
    _activo = _selectedRelacion?.activo ?? true;
  }

  @override
  void dispose() {
    _nivelCtrl.dispose();
    _numeroCertificadoCtrl.dispose();
    _vigenciaHastaCtrl.dispose();
    super.dispose();
  }

  void _openForm([EmpleadoEspecialidad? relacion]) {
    setState(() {
      _selectedRelacion = relacion;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedRelacion = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idEmpleado == null || _idEspecialidad == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar empleado y especialidad')));
      return;
    }
    
    final newRelacion = EmpleadoEspecialidad(
      idEmpleadoEspecialidad: _selectedRelacion?.idEmpleadoEspecialidad,
      idEmpleado: _idEmpleado!,
      idEspecialidad: _idEspecialidad!,
      nivel: _nivelCtrl.text.trim(),
      numeroCertificado: _numeroCertificadoCtrl.text.trim().isEmpty ? null : _numeroCertificadoCtrl.text.trim(),
      vigenciaHasta: _vigenciaHastaCtrl.text.trim().isEmpty ? null : _vigenciaHastaCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedRelacion == null) {
        await ref.read(empleadosEspecialidadesProvider.notifier).addEmpleadoEspecialidad(newRelacion);
      } else {
        await ref.read(empleadosEspecialidadesProvider.notifier).updateEmpleadoEspecialidad(newRelacion);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(EmpleadoEspecialidad relacion) async {
    final action = relacion.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${relacion.activo ? 'Desactivar' : 'Activar'} Relación', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action esta relación?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(relacion.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && relacion.idEmpleadoEspecialidad != null) {
      try {
        await ref.read(empleadosEspecialidadesProvider.notifier).deleteEmpleadoEspecialidad(relacion.idEmpleadoEspecialidad!);
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
        constraints: BoxConstraints(maxWidth: 1000),
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
                    _isEditing ? (_selectedRelacion == null ? 'Nueva Relación' : 'Editar Relación') : 'Gestión de Empleado - Especialidad',
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
    final relacionesAsync = ref.watch(empleadosEspecialidadesProvider);
    final empleadosAsync = ref.watch(helperEmpleadosProvider);
    final especialidadesAsync = ref.watch(helperEspecialidadesProvider);

    return relacionesAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final relaciones = rawList.where((e) => e.activo).toList();
        if (relaciones.isEmpty) {
          return Center(
            child: Text('No hay relaciones registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        // Helpers para extraer nombres
        String getNombreEmpleado(int id) {
          return empleadosAsync.maybeWhen(
            data: (list) => list.firstWhere((e) => e['id'] == id, orElse: () => {'nombre': 'Desconocido'})['nombre'] as String,
            orElse: () => 'Cargando...',
          );
        }

        String getNombreEspecialidad(int id) {
          return especialidadesAsync.maybeWhen(
            data: (list) => list.firstWhere((e) => e['id'] == id, orElse: () => {'nombre': 'Desconocida'})['nombre'] as String,
            orElse: () => 'Cargando...',
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('EMPLEADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ESPECIALIDAD', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('NIVEL', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('CERTIFICADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('VIGENCIA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: relaciones.map((e) => DataRow(
            cells: [
              DataCell(Text(getNombreEmpleado(e.idEmpleado), style: TextStyle(color: context.textColor))),
              DataCell(Text(getNombreEspecialidad(e.idEspecialidad), style: TextStyle(color: context.textColor))),
              DataCell(Text(e.nivel, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.numeroCertificado ?? '-', style: TextStyle(color: context.textColor))),
              DataCell(Text(e.vigenciaHasta ?? '-', style: TextStyle(color: context.textColor))),
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
          searchableValues: relaciones.map((e) => '${getNombreEmpleado(e.idEmpleado)} ${getNombreEspecialidad(e.idEspecialidad)} ${e.nivel}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final empleadosAsync = ref.watch(helperEmpleadosProvider);
    final especialidadesAsync = ref.watch(helperEspecialidadesProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asignación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownAsync('Empleado *', _idEmpleado, empleadosAsync, (val) => setState(() => _idEmpleado = val as int?)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownAsync('Especialidad *', _idEspecialidad, especialidadesAsync, (val) => setState(() => _idEspecialidad = val as int?)),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text('Detalles de la Especialidad', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Nivel *', _nivelCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Número de Certificado', _numeroCertificadoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Vigencia Hasta', _vigenciaHastaCtrl)),
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

  Widget _buildDatePicker(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.blue,
                      onPrimary: Colors.white,
                      surface: context.surfaceColor,
                      onSurface: context.textColor,
                    ),
                    dialogBackgroundColor: context.surfaceColor,
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              controller.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }
          },
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            suffixIcon: Icon(Icons.calendar_today, color: context.mutedTextColor, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownAsync(String label, int? value, AsyncValue<List<Map<String, dynamic>>> asyncValue, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        asyncValue.when(
          loading: () => LinearProgressIndicator(),
          error: (e, st) => Text('Error al cargar', style: TextStyle(color: AppColors.red)),
          data: (items) {
            // Filtrar activos, pero siempre incluir el que ya esté seleccionado (para edición)
            final activeItems = items; // Podrías filtrar por activo si el endpoint lo expone

            final valueExists = activeItems.any((e) => e['id'] == value);
            final safeValue = valueExists ? value : null;

            return DropdownButtonFormField<int>(
              value: safeValue,
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
              items: activeItems.map((e) => DropdownMenuItem<int>(
                value: e['id'] as int,
                child: Text(e['nombre'].toString()),
              )).toList(),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
