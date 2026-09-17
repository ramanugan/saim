import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/empleado.dart';
import '../../providers/empleados_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudEmpleadosModal extends ConsumerStatefulWidget {
  const CrudEmpleadosModal({super.key});

  @override
  ConsumerState<CrudEmpleadosModal> createState() => _CrudEmpleadosModalState();
}

class _CrudEmpleadosModalState extends ConsumerState<CrudEmpleadosModal> {
  bool _isEditing = false;
  Empleado? _selectedEmpleado;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numeroEmpleadoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoPaternoCtrl;
  late TextEditingController _apellidoMaternoCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _correoCtrl;
  late TextEditingController _puestoCtrl;
  late TextEditingController _tipoEmpleadoCtrl;
  late TextEditingController _fechaIngresoCtrl;

  String _estadoLaboral = 'ACTIVO';
  bool _activo = true;

  final _estadosLaborales = ['ACTIVO', 'INACTIVO', 'PERMISO', 'VACACIONES', 'INCAPACIDAD'];
  final _tiposEmpleado = ['INTERNO', 'EXTERNO', 'CONTRATISTA'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _numeroEmpleadoCtrl = TextEditingController(text: _selectedEmpleado?.numeroEmpleado ?? '');
    _nombreCtrl = TextEditingController(text: _selectedEmpleado?.nombre ?? '');
    _apellidoPaternoCtrl = TextEditingController(text: _selectedEmpleado?.apellidoPaterno ?? '');
    _apellidoMaternoCtrl = TextEditingController(text: _selectedEmpleado?.apellidoMaterno ?? '');
    _telefonoCtrl = TextEditingController(text: _selectedEmpleado?.telefono ?? '');
    _correoCtrl = TextEditingController(text: _selectedEmpleado?.correo ?? '');
    _puestoCtrl = TextEditingController(text: _selectedEmpleado?.puesto ?? '');
    _tipoEmpleadoCtrl = TextEditingController(text: _selectedEmpleado?.tipoEmpleado ?? _tiposEmpleado[0]);
    _fechaIngresoCtrl = TextEditingController(text: _selectedEmpleado?.fechaIngreso ?? '');
    
    _estadoLaboral = _selectedEmpleado?.estadoLaboral ?? 'ACTIVO';
    if (!_estadosLaborales.contains(_estadoLaboral)) _estadoLaboral = _estadosLaborales[0];
    
    _activo = _selectedEmpleado?.activo ?? true;
  }

  @override
  void dispose() {
    _numeroEmpleadoCtrl.dispose();
    _nombreCtrl.dispose();
    _apellidoPaternoCtrl.dispose();
    _apellidoMaternoCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _puestoCtrl.dispose();
    _tipoEmpleadoCtrl.dispose();
    _fechaIngresoCtrl.dispose();
    super.dispose();
  }

  void _openForm([Empleado? empleado]) {
    setState(() {
      _selectedEmpleado = empleado;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedEmpleado = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newEmpleado = Empleado(
      idEmpleado: _selectedEmpleado?.idEmpleado,
      numeroEmpleado: _numeroEmpleadoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      apellidoPaterno: _apellidoPaternoCtrl.text.trim(),
      apellidoMaterno: _apellidoMaternoCtrl.text.trim().isEmpty ? null : _apellidoMaternoCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      correo: _correoCtrl.text.trim().isEmpty ? null : _correoCtrl.text.trim(),
      puesto: _puestoCtrl.text.trim(),
      tipoEmpleado: _tipoEmpleadoCtrl.text.trim(),
      fechaIngreso: _fechaIngresoCtrl.text.trim().isEmpty ? null : _fechaIngresoCtrl.text.trim(),
      estadoLaboral: _estadoLaboral,
      activo: _activo,
    );

    try {
      if (_selectedEmpleado == null) {
        await ref.read(empleadosProvider.notifier).addEmpleado(newEmpleado);
      } else {
        await ref.read(empleadosProvider.notifier).updateEmpleado(newEmpleado);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Empleado empleado) async {
    final action = empleado.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${empleado.activo ? 'Desactivar' : 'Activar'} Empleado', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action este empleado?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(empleado.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && empleado.idEmpleado != null) {
      try {
        await ref.read(empleadosProvider.notifier).deleteEmpleado(empleado.idEmpleado!);
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
        constraints: BoxConstraints(maxWidth: 1100),
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
                    _isEditing ? (_selectedEmpleado == null ? 'Nuevo Empleado' : 'Editar Empleado') : 'Gestión de Empleados',
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
    final empleadosAsync = ref.watch(empleadosProvider);

    return empleadosAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final empleados = rawList.where((e) => e.activo).toList();
        if (empleados.isEmpty) {
          return Center(
            child: Text('No hay empleados registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('NÚMERO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('NOMBRE COMPLETO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('PUESTO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('TIPO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ESTADO OPE.', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: empleados.map((e) => DataRow(
            cells: [
              DataCell(Text(e.numeroEmpleado, style: TextStyle(color: context.textColor))),
              DataCell(Text('${e.nombre} ${e.apellidoPaterno} ${e.apellidoMaterno ?? ''}'.trim(), style: TextStyle(color: context.textColor))),
              DataCell(Text(e.puesto, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.tipoEmpleado, style: TextStyle(color: context.textColor))),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (e.estadoLaboral == 'ACTIVO' ? AppColors.green : AppColors.blue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    e.estadoLaboral,
                    style: TextStyle(
                      color: e.estadoLaboral == 'ACTIVO' ? AppColors.green : AppColors.blue,
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
          searchableValues: empleados.map((e) => '${e.numeroEmpleado} ${e.nombre} ${e.apellidoPaterno} ${e.puesto}').toList(),
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
              Text('Información Personal', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Nombre *', _nombreCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Apellido Paterno *', _apellidoPaternoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Apellido Materno', _apellidoMaternoCtrl)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Teléfono', _telefonoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Correo', _correoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: SizedBox()),
                ],
              ),
              SizedBox(height: 32),
              Text('Información Laboral', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Número de Empleado *', _numeroEmpleadoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Puesto *', _puestoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Tipo Empleado *', _tipoEmpleadoCtrl.text, _tiposEmpleado, (v) => setState(() => _tipoEmpleadoCtrl.text = v.toString()))),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDatePicker('Fecha Ingreso *', _fechaIngresoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Estado Laboral *', _estadoLaboral, _estadosLaborales, (v) => setState(() => _estadoLaboral = v.toString()))),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo en Sistema', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
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
              firstDate: DateTime(1950),
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
}
