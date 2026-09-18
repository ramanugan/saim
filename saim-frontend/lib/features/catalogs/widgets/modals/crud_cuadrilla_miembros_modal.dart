import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/cuadrilla_miembro.dart';
import '../../providers/cuadrilla_miembros_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudCuadrillaMiembrosModal extends ConsumerStatefulWidget {
  const CrudCuadrillaMiembrosModal({super.key});

  @override
  ConsumerState<CrudCuadrillaMiembrosModal> createState() => _CrudCuadrillaMiembrosModalState();
}

class _CrudCuadrillaMiembrosModalState extends ConsumerState<CrudCuadrillaMiembrosModal> {
  bool _isEditing = false;
  CuadrillaMiembro? _selectedMiembro;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;

  int? _idCuadrilla;
  int? _idEmpleado;
  String _rolCuadrilla = 'RESPONSABLE';
  bool _activo = true;

  final _roles = ['RESPONSABLE', 'AYUDANTE', 'TECNICO', 'SUPERVISOR'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _fechaInicioCtrl = TextEditingController(text: _selectedMiembro?.fechaInicio ?? '');
    _fechaFinCtrl = TextEditingController(text: _selectedMiembro?.fechaFin ?? '');
    
    _idCuadrilla = _selectedMiembro?.idCuadrilla == 0 ? null : _selectedMiembro?.idCuadrilla;
    _idEmpleado = _selectedMiembro?.idEmpleado == 0 ? null : _selectedMiembro?.idEmpleado;

    _rolCuadrilla = _selectedMiembro?.rolCuadrilla ?? 'RESPONSABLE';
    if (!_roles.contains(_rolCuadrilla)) _rolCuadrilla = _roles[0];

    _activo = _selectedMiembro?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    super.dispose();
  }

  void _openForm([CuadrillaMiembro? miembro]) {
    setState(() {
      _selectedMiembro = miembro;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedMiembro = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCuadrilla == null || _idEmpleado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar Cuadrilla y Empleado')));
      return;
    }
    
    final newMiembro = CuadrillaMiembro(
      idCuadrillaMiembro: _selectedMiembro?.idCuadrillaMiembro,
      idCuadrilla: _idCuadrilla!,
      idEmpleado: _idEmpleado!,
      rolCuadrilla: _rolCuadrilla,
      fechaInicio: _fechaInicioCtrl.text.trim(),
      fechaFin: _fechaFinCtrl.text.trim().isEmpty ? null : _fechaFinCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedMiembro == null) {
        await ref.read(cuadrillaMiembrosProvider.notifier).addCuadrillaMiembro(newMiembro);
      } else {
        await ref.read(cuadrillaMiembrosProvider.notifier).updateCuadrillaMiembro(newMiembro);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(CuadrillaMiembro miembro) async {
    final action = miembro.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${miembro.activo ? 'Desactivar' : 'Activar'} Miembro', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action este miembro?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(miembro.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && miembro.idCuadrillaMiembro != null) {
      try {
        await ref.read(cuadrillaMiembrosProvider.notifier).deleteCuadrillaMiembro(miembro.idCuadrillaMiembro!);
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
        constraints: BoxConstraints(maxWidth: 900),
        height: MediaQuery.of(context).size.height * 0.85,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? (_selectedMiembro == null ? 'Nuevo Miembro de Cuadrilla' : 'Editar Miembro de Cuadrilla') : 'Gestión de Miembros de Cuadrilla',
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
    final asyncData = ref.watch(cuadrillaMiembrosProvider);
    final cuadrillasAsync = ref.watch(helperCuadrillasForMiembroProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForMiembroProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay miembros registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('CUADRILLA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('EMPLEADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ROL', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('INICIO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            String cuadrillaText = e.idCuadrilla.toString();
            cuadrillasAsync.whenData((items) {
              final found = items.firstWhere((c) => c['id_cuadrilla'] == e.idCuadrilla, orElse: () => {});
              if (found.isNotEmpty) cuadrillaText = found['nombre'] ?? found['codigo'];
            });

            String empleadoText = e.idEmpleado.toString();
            empleadosAsync.whenData((items) {
              final found = items.firstWhere((emp) => emp['id_empleado'] == e.idEmpleado, orElse: () => {});
              if (found.isNotEmpty) empleadoText = '${found['nombres']} ${found['apellidos']}';
            });

            return DataRow(
              cells: [
                DataCell(Text(cuadrillaText, style: TextStyle(color: context.textColor))),
                DataCell(Text(empleadoText, style: TextStyle(color: context.textColor))),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.rolCuadrilla,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(e.fechaInicio, style: TextStyle(color: context.textColor))),
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
          searchableValues: lista.map((e) => '${e.idCuadrilla} ${e.idEmpleado} ${e.rolCuadrilla}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final cuadrillasAsync = ref.watch(helperCuadrillasForMiembroProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForMiembroProvider);

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
                    child: _buildDropdownGenerico(
                      'Cuadrilla *', 
                      _idCuadrilla, 
                      cuadrillasAsync, 
                      'id_cuadrilla', 
                      (e) => '${e['codigo']} - ${e['nombre']}', 
                      (val) => setState(() => _idCuadrilla = val as int?)
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
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
                  Expanded(child: _buildLocalDropdown('Rol en la Cuadrilla *', _rolCuadrilla, _roles, (val) => setState(() => _rolCuadrilla = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Fecha de Inicio *', _fechaInicioCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Fecha de Fin', _fechaFinCtrl, required: false)),
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

  Widget _buildDatePicker(String label, TextEditingController controller, {bool required = false}) {
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
