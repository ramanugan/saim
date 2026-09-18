import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/jornada_servicio.dart';
import '../../providers/jornadas_servicio_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudJornadasServicioModal extends ConsumerStatefulWidget {
  const CrudJornadasServicioModal({super.key});

  @override
  ConsumerState<CrudJornadasServicioModal> createState() => _CrudJornadasServicioModalState();
}

class _CrudJornadasServicioModalState extends ConsumerState<CrudJornadasServicioModal> {
  bool _isEditing = false;
  JornadaServicio? _selectedJornada;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _numeroJornadaCtrl;
  late TextEditingController _fechaCtrl;
  late TextEditingController _horaLlegadaCtrl;
  late TextEditingController _horaInicioEfectivoCtrl;
  late TextEditingController _horaFinEfectivoCtrl;
  late TextEditingController _horaSalidaCtrl;
  late TextEditingController _minutosPausaCtrl;
  late TextEditingController _observacionesCtrl;

  int? _idServicio;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _numeroJornadaCtrl = TextEditingController(text: _selectedJornada?.numeroJornada.toString() ?? '1');
    _fechaCtrl = TextEditingController(text: _selectedJornada?.fecha ?? '');
    _horaLlegadaCtrl = TextEditingController(text: _selectedJornada?.horaLlegada ?? '');
    _horaInicioEfectivoCtrl = TextEditingController(text: _selectedJornada?.horaInicioEfectivo ?? '');
    _horaFinEfectivoCtrl = TextEditingController(text: _selectedJornada?.horaFinEfectivo ?? '');
    _horaSalidaCtrl = TextEditingController(text: _selectedJornada?.horaSalida ?? '');
    _minutosPausaCtrl = TextEditingController(text: _selectedJornada?.minutosPausa.toString() ?? '0');
    _observacionesCtrl = TextEditingController(text: _selectedJornada?.observaciones ?? '');
    
    _idServicio = _selectedJornada?.idServicio == 0 ? null : _selectedJornada?.idServicio;
    _activo = _selectedJornada?.activo ?? true;
  }

  @override
  void dispose() {
    _numeroJornadaCtrl.dispose();
    _fechaCtrl.dispose();
    _horaLlegadaCtrl.dispose();
    _horaInicioEfectivoCtrl.dispose();
    _horaFinEfectivoCtrl.dispose();
    _horaSalidaCtrl.dispose();
    _minutosPausaCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  void _openForm([JornadaServicio? jornada]) {
    setState(() {
      _selectedJornada = jornada;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedJornada = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idServicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar un Servicio')));
      return;
    }
    
    final newJornada = JornadaServicio(
      idJornada: _selectedJornada?.idJornada,
      idServicio: _idServicio!,
      numeroJornada: int.tryParse(_numeroJornadaCtrl.text.trim()) ?? 1,
      fecha: _fechaCtrl.text.trim(),
      horaLlegada: _horaLlegadaCtrl.text.trim().isEmpty ? null : _horaLlegadaCtrl.text.trim(),
      horaInicioEfectivo: _horaInicioEfectivoCtrl.text.trim(),
      horaFinEfectivo: _horaFinEfectivoCtrl.text.trim(),
      horaSalida: _horaSalidaCtrl.text.trim().isEmpty ? null : _horaSalidaCtrl.text.trim(),
      minutosPausa: int.tryParse(_minutosPausaCtrl.text.trim()) ?? 0,
      observaciones: _observacionesCtrl.text.trim().isEmpty ? null : _observacionesCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedJornada == null) {
        await ref.read(jornadasServicioProvider.notifier).addJornadaServicio(newJornada);
      } else {
        await ref.read(jornadasServicioProvider.notifier).updateJornadaServicio(newJornada);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(JornadaServicio jornada) async {
    final action = jornada.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${jornada.activo ? 'Desactivar' : 'Activar'} Jornada', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action esta jornada?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(jornada.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && jornada.idJornada != null) {
      try {
        await ref.read(jornadasServicioProvider.notifier).deleteJornadaServicio(jornada.idJornada!);
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
                    _isEditing ? (_selectedJornada == null ? 'Nueva Jornada de Servicio' : 'Editar Jornada') : 'Gestión de Jornadas de Servicio',
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
    final asyncData = ref.watch(jornadasServicioProvider);
    final serviciosAsync = ref.watch(helperServiciosForJornadaProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay jornadas registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('SERVICIO (FOLIO)', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('# JORNADA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('FECHA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('INICIO EFEC.', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            String servicioText = e.idServicio.toString();
            serviciosAsync.whenData((items) {
              final found = items.firstWhere((s) => s['id_servicio'] == e.idServicio, orElse: () => {});
              if (found.isNotEmpty) servicioText = found['folio_interno'] ?? servicioText;
            });

            return DataRow(
              cells: [
                DataCell(Text(servicioText, style: TextStyle(color: context.textColor))),
                DataCell(Text(e.numeroJornada.toString(), style: TextStyle(color: context.textColor))),
                DataCell(Text(e.fecha, style: TextStyle(color: context.textColor))),
                DataCell(Text(e.horaInicioEfectivo, style: TextStyle(color: context.textColor))),
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
          searchableValues: lista.map((e) => '${e.idServicio} ${e.numeroJornada} ${e.fecha}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final serviciosAsync = ref.watch(helperServiciosForJornadaProvider);

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
                      'Servicio *', 
                      _idServicio, 
                      serviciosAsync, 
                      'id_servicio', 
                      (e) => '${e['folio_interno']} - ${e['tipo_mantenimiento']}', 
                      (val) => setState(() => _idServicio = val as int?)
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('No. Jornada *', _numeroJornadaCtrl, isNumber: true, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Fecha *', _fechaCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateTimePicker('Hora Llegada', _horaLlegadaCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Inicio Efectivo *', _horaInicioEfectivoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Fin Efectivo *', _horaFinEfectivoCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateTimePicker('Hora Salida', _horaSalidaCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Minutos Pausa *', _minutosPausaCtrl, isNumber: true, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: SizedBox()), // Placeholder for alignment
                ],
              ),
              SizedBox(height: 16),
              _buildTextField('Observaciones', _observacionesCtrl, maxLines: 3),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
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
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) => _buildThemeForPicker(context, child),
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
