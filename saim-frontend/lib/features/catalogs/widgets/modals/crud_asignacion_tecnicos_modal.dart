import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/asignacion_tecnico.dart';
import '../../providers/asignacion_tecnicos_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudAsignacionTecnicosModal extends ConsumerStatefulWidget {
  const CrudAsignacionTecnicosModal({super.key});

  @override
  ConsumerState<CrudAsignacionTecnicosModal> createState() => _CrudAsignacionTecnicosModalState();
}

class _CrudAsignacionTecnicosModalState extends ConsumerState<CrudAsignacionTecnicosModal> {
  bool _isEditing = false;
  AsignacionTecnico? _selectedAsignacionTecnico;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _horaInicioAsignadaCtrl;
  late TextEditingController _horaFinAsignadaCtrl;

  int? _idAsignacion;
  int? _idEmpleado;
  String _rol = 'RESPONSABLE';
  bool _esPlaneado = true;
  bool _confirmado = false;
  bool _activo = true;

  final _rolesList = ['RESPONSABLE', 'AYUDANTE', 'TECNICO', 'SUPERVISOR'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _horaInicioAsignadaCtrl = TextEditingController(text: _selectedAsignacionTecnico?.horaInicioAsignada ?? '');
    _horaFinAsignadaCtrl = TextEditingController(text: _selectedAsignacionTecnico?.horaFinAsignada ?? '');
    
    _idAsignacion = _selectedAsignacionTecnico?.idAsignacion == 0 ? null : _selectedAsignacionTecnico?.idAsignacion;
    _idEmpleado = _selectedAsignacionTecnico?.idEmpleado == 0 ? null : _selectedAsignacionTecnico?.idEmpleado;

    _rol = _selectedAsignacionTecnico?.rol ?? 'RESPONSABLE';
    if (!_rolesList.contains(_rol)) _rol = _rolesList[0];

    _esPlaneado = _selectedAsignacionTecnico?.esPlaneado ?? true;
    _confirmado = _selectedAsignacionTecnico?.confirmado ?? false;
    _activo = _selectedAsignacionTecnico?.activo ?? true;
  }

  @override
  void dispose() {
    _horaInicioAsignadaCtrl.dispose();
    _horaFinAsignadaCtrl.dispose();
    super.dispose();
  }

  void _openForm([AsignacionTecnico? tecnico]) {
    setState(() {
      _selectedAsignacionTecnico = tecnico;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedAsignacionTecnico = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idAsignacion == null || _idEmpleado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar Asignación y Empleado')));
      return;
    }
    
    final newTecnico = AsignacionTecnico(
      idAsignacionTecnico: _selectedAsignacionTecnico?.idAsignacionTecnico,
      idAsignacion: _idAsignacion!,
      idEmpleado: _idEmpleado!,
      rol: _rol,
      esPlaneado: _esPlaneado,
      confirmado: _confirmado,
      horaInicioAsignada: _horaInicioAsignadaCtrl.text.trim(),
      horaFinAsignada: _horaFinAsignadaCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedAsignacionTecnico == null) {
        await ref.read(asignacionTecnicosProvider.notifier).addAsignacionTecnico(newTecnico);
      } else {
        await ref.read(asignacionTecnicosProvider.notifier).updateAsignacionTecnico(newTecnico);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(AsignacionTecnico tecnico) async {
    final action = tecnico.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${tecnico.activo ? 'Desactivar' : 'Activar'} Técnico Asignado', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action a este técnico de la asignación?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(tecnico.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && tecnico.idAsignacionTecnico != null) {
      try {
        await ref.read(asignacionTecnicosProvider.notifier).deleteAsignacionTecnico(tecnico.idAsignacionTecnico!);
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
                    _isEditing ? (_selectedAsignacionTecnico == null ? 'Nuevo Técnico Asignado' : 'Editar Técnico Asignado') : 'Gestión de Técnicos Asignados',
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
    final asyncData = ref.watch(asignacionTecnicosProvider);
    final asignacionesAsync = ref.watch(helperAsignacionServiciosForTecnicoProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForAsignacionTecnicoProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay técnicos asignados registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('ASIGNACIÓN PADRE', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('EMPLEADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ROL', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('CONFIRMADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            String asignacionText = e.idAsignacion.toString();
            asignacionesAsync.whenData((items) {
              final found = items.firstWhere((a) => a['id_asignacion'] == e.idAsignacion, orElse: () => {});
              if (found.isNotEmpty) asignacionText = 'ID Asignación: ${found['id_asignacion']}';
            });

            String empleadoText = e.idEmpleado.toString();
            empleadosAsync.whenData((items) {
              final found = items.firstWhere((emp) => emp['id_empleado'] == e.idEmpleado, orElse: () => {});
              if (found.isNotEmpty) empleadoText = '${found['nombres']} ${found['apellidos']}';
            });

            return DataRow(
              cells: [
                DataCell(Text(asignacionText, style: TextStyle(color: context.textColor))),
                DataCell(Text(empleadoText, style: TextStyle(color: context.textColor))),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.rol,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Icon(
                  e.confirmado ? Icons.check_circle : Icons.pending,
                  color: e.confirmado ? AppColors.green : AppColors.amber,
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
          searchableValues: lista.map((e) => '${e.idAsignacion} ${e.idEmpleado} ${e.rol}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final asignacionesAsync = ref.watch(helperAsignacionServiciosForTecnicoProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForAsignacionTecnicoProvider);

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
                  Expanded(
                    flex: 2,
                    child: _buildDropdownGenerico(
                      'Asignación (Padre) *', 
                      _idAsignacion, 
                      asignacionesAsync, 
                      'id_asignacion', 
                      (e) => 'Asignación ID ${e['id_asignacion']} - Serv. ${e['id_servicio']} (${e['estado']})', 
                      (val) => setState(() => _idAsignacion = val as int?)
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildDropdownGenerico(
                      'Empleado *', 
                      _idEmpleado, 
                      empleadosAsync, 
                      'id_empleado', 
                      (e) => '${e['nombres']} ${e['apellidos']}', 
                      (val) => setState(() => _idEmpleado = val as int?)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLocalDropdown('Rol *', _rol, _rolesList, (val) => setState(() => _rol = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Inicio Asignado *', _horaInicioAsignadaCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Fin Asignado *', _horaFinAsignadaCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildSwitch('Es Planeado', _esPlaneado, (val) => setState(() => _esPlaneado = val))),
                  SizedBox(width: 16),
                  Expanded(child: _buildSwitch('Confirmado', _confirmado, (val) => setState(() => _confirmado = val))),
                  SizedBox(width: 16),
                  Expanded(child: SizedBox()), // Placeholder
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

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        Container(
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

  Widget _buildDateTimePicker(String label, TextEditingController controller, {bool required = false}) {
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
              builder: (context, child) => _buildThemeForPicker(context, child),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) => _buildThemeForPicker(context, child),
              );
              if (time != null) {
                controller.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
              }
            }
          },
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            suffixIcon: Icon(Icons.access_time, color: context.mutedTextColor, size: 20),
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

  Widget _buildThemeForPicker(BuildContext context, Widget? child) {
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

  Widget _buildDropdownGenerico(String label, int? value, AsyncValue<List<Map<String, dynamic>>> asyncValue, String idKey, String Function(Map<String, dynamic>) labelBuilder, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        asyncValue.when(
          loading: () => LinearProgressIndicator(),
          error: (e, st) => Text('Error al cargar', style: TextStyle(color: AppColors.red)),
          data: (items) {
            final valueExists = items.any((e) => e[idKey] == value);
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
              items: items.map((e) => DropdownMenuItem<int>(
                value: e[idKey] as int,
                child: Text(labelBuilder(e)),
              )).toList(),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
