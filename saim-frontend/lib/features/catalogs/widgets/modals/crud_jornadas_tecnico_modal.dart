import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/jornada_tecnico.dart';
import '../../providers/jornadas_tecnico_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudJornadasTecnicoModal extends ConsumerStatefulWidget {
  const CrudJornadasTecnicoModal({super.key});

  @override
  ConsumerState<CrudJornadasTecnicoModal> createState() => _CrudJornadasTecnicoModalState();
}

class _CrudJornadasTecnicoModalState extends ConsumerState<CrudJornadasTecnicoModal> {
  bool _isEditing = false;
  JornadaTecnico? _selectedJornadaTecnico;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _horaInicioCtrl;
  late TextEditingController _horaFinCtrl;
  late TextEditingController _minutosEfectivosCtrl;

  int? _idJornada;
  int? _idEmpleado;
  String _participacion = 'TOTAL';
  bool _activo = true;

  final _participacionList = ['TOTAL', 'PARCIAL', 'SOPORTE'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _horaInicioCtrl = TextEditingController(text: _selectedJornadaTecnico?.horaInicio ?? '');
    _horaFinCtrl = TextEditingController(text: _selectedJornadaTecnico?.horaFin ?? '');
    _minutosEfectivosCtrl = TextEditingController(text: _selectedJornadaTecnico?.minutosEfectivos.toString() ?? '0');
    
    _idJornada = _selectedJornadaTecnico?.idJornada == 0 ? null : _selectedJornadaTecnico?.idJornada;
    _idEmpleado = _selectedJornadaTecnico?.idEmpleado == 0 ? null : _selectedJornadaTecnico?.idEmpleado;

    _participacion = _selectedJornadaTecnico?.participacion ?? 'TOTAL';
    if (!_participacionList.contains(_participacion)) _participacion = _participacionList[0];

    _activo = _selectedJornadaTecnico?.activo ?? true;
  }

  @override
  void dispose() {
    _horaInicioCtrl.dispose();
    _horaFinCtrl.dispose();
    _minutosEfectivosCtrl.dispose();
    super.dispose();
  }

  void _openForm([JornadaTecnico? tecnico]) {
    setState(() {
      _selectedJornadaTecnico = tecnico;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedJornadaTecnico = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idJornada == null || _idEmpleado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar Jornada y Empleado')));
      return;
    }
    
    final newJornadaTecnico = JornadaTecnico(
      idJornadaTecnico: _selectedJornadaTecnico?.idJornadaTecnico,
      idJornada: _idJornada!,
      idEmpleado: _idEmpleado!,
      horaInicio: _horaInicioCtrl.text.trim(),
      horaFin: _horaFinCtrl.text.trim(),
      minutosEfectivos: int.tryParse(_minutosEfectivosCtrl.text.trim()) ?? 0,
      participacion: _participacion,
      activo: _activo,
    );

    try {
      if (_selectedJornadaTecnico == null) {
        await ref.read(jornadasTecnicoProvider.notifier).addJornadaTecnico(newJornadaTecnico);
      } else {
        await ref.read(jornadasTecnicoProvider.notifier).updateJornadaTecnico(newJornadaTecnico);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(JornadaTecnico tecnico) async {
    final action = tecnico.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${tecnico.activo ? 'Desactivar' : 'Activar'} Técnico', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action este técnico en la jornada?', style: TextStyle(color: context.textColor)),
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

    if (confirm == true && tecnico.idJornadaTecnico != null) {
      try {
        await ref.read(jornadasTecnicoProvider.notifier).deleteJornadaTecnico(tecnico.idJornadaTecnico!);
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
                    _isEditing ? (_selectedJornadaTecnico == null ? 'Nuevo Técnico en Jornada' : 'Editar Técnico en Jornada') : 'Gestión de Técnicos en Jornada',
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
    final asyncData = ref.watch(jornadasTecnicoProvider);
    final jornadasAsync = ref.watch(helperJornadasForTecnicoProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForJornadaProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay técnicos registrados en jornadas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('JORNADA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('EMPLEADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('PARTICIPACIÓN', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('INICIO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            String jornadaText = e.idJornada.toString();
            jornadasAsync.whenData((items) {
              final found = items.firstWhere((j) => j['id_jornada'] == e.idJornada, orElse: () => {});
              if (found.isNotEmpty) jornadaText = 'Jornada #${found['numero_jornada']} (${found['fecha']})';
            });

            String empleadoText = e.idEmpleado.toString();
            empleadosAsync.whenData((items) {
              final found = items.firstWhere((emp) => emp['id_empleado'] == e.idEmpleado, orElse: () => {});
              if (found.isNotEmpty) empleadoText = '${found['nombres']} ${found['apellidos']}';
            });

            return DataRow(
              cells: [
                DataCell(Text(jornadaText, style: TextStyle(color: context.textColor))),
                DataCell(Text(empleadoText, style: TextStyle(color: context.textColor))),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.participacion,
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(e.horaInicio, style: TextStyle(color: context.textColor))),
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
          searchableValues: lista.map((e) => '${e.idJornada} ${e.idEmpleado} ${e.participacion}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final jornadasAsync = ref.watch(helperJornadasForTecnicoProvider);
    final empleadosAsync = ref.watch(helperEmpleadosForJornadaProvider);

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
                      'Jornada de Servicio *', 
                      _idJornada, 
                      jornadasAsync, 
                      'id_jornada', 
                      (e) => 'ID ${e['id_jornada']} | Jornada #${e['numero_jornada']} - ${e['fecha']}', 
                      (val) => setState(() => _idJornada = val as int?)
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildDropdownGenerico(
                      'Técnico (Empleado) *', 
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
                  Expanded(child: _buildDateTimePicker('Hora Inicio *', _horaInicioCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Hora Fin *', _horaFinCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Minutos Efectivos *', _minutosEfectivosCtrl, isNumber: true, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Participación *', _participacion, _participacionList, (val) => setState(() => _participacion = val as String))),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
