import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/asignacion_servicio.dart';
import '../../providers/asignacion_servicios_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudAsignacionServiciosModal extends ConsumerStatefulWidget {
  const CrudAsignacionServiciosModal({super.key});

  @override
  ConsumerState<CrudAsignacionServiciosModal> createState() => _CrudAsignacionServiciosModalState();
}

class _CrudAsignacionServiciosModalState extends ConsumerState<CrudAsignacionServiciosModal> {
  bool _isEditing = false;
  AsignacionServicio? _selectedAsignacion;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _fechaAsignacionCtrl;
  late TextEditingController _fechaInicioVigenciaCtrl;
  late TextEditingController _fechaFinVigenciaCtrl;
  late TextEditingController _motivoCambioCtrl;

  int? _idServicio;
  int? _idCuadrilla;
  String _estado = 'VIGENTE';
  bool _activo = true;

  final _estadosList = ['VIGENTE', 'FINALIZADA', 'CANCELADA'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _fechaAsignacionCtrl = TextEditingController(text: _selectedAsignacion?.fechaAsignacion ?? '');
    _fechaInicioVigenciaCtrl = TextEditingController(text: _selectedAsignacion?.fechaInicioVigencia ?? '');
    _fechaFinVigenciaCtrl = TextEditingController(text: _selectedAsignacion?.fechaFinVigencia ?? '');
    _motivoCambioCtrl = TextEditingController(text: _selectedAsignacion?.motivoCambio ?? '');

    _idServicio = _selectedAsignacion?.idServicio == 0 ? null : _selectedAsignacion?.idServicio;
    _idCuadrilla = _selectedAsignacion?.idCuadrilla == 0 ? null : _selectedAsignacion?.idCuadrilla;

    _estado = _selectedAsignacion?.estado ?? 'VIGENTE';
    if (!_estadosList.contains(_estado)) _estado = _estadosList[0];

    _activo = _selectedAsignacion?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaAsignacionCtrl.dispose();
    _fechaInicioVigenciaCtrl.dispose();
    _fechaFinVigenciaCtrl.dispose();
    _motivoCambioCtrl.dispose();
    super.dispose();
  }

  void _openForm([AsignacionServicio? asignacion]) {
    setState(() {
      _selectedAsignacion = asignacion;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedAsignacion = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idServicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar un Servicio')));
      return;
    }
    
    final newAsignacion = AsignacionServicio(
      idAsignacion: _selectedAsignacion?.idAsignacion,
      idServicio: _idServicio!,
      idCuadrilla: _idCuadrilla,
      fechaAsignacion: _fechaAsignacionCtrl.text.trim(),
      fechaInicioVigencia: _fechaInicioVigenciaCtrl.text.trim(),
      fechaFinVigencia: _fechaFinVigenciaCtrl.text.trim().isEmpty ? null : _fechaFinVigenciaCtrl.text.trim(),
      motivoCambio: _motivoCambioCtrl.text.trim().isEmpty ? null : _motivoCambioCtrl.text.trim(),
      estado: _estado,
      activo: _activo,
    );

    try {
      if (_selectedAsignacion == null) {
        await ref.read(asignacionServiciosProvider.notifier).addAsignacionServicio(newAsignacion);
      } else {
        await ref.read(asignacionServiciosProvider.notifier).updateAsignacionServicio(newAsignacion);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(AsignacionServicio asignacion) async {
    final action = asignacion.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${asignacion.activo ? 'Desactivar' : 'Activar'} Asignación', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action esta asignación?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(asignacion.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && asignacion.idAsignacion != null) {
      try {
        await ref.read(asignacionServiciosProvider.notifier).deleteAsignacionServicio(asignacion.idAsignacion!);
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
                    _isEditing ? (_selectedAsignacion == null ? 'Nueva Asignación de Servicio' : 'Editar Asignación') : 'Gestión de Asignaciones de Servicio',
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
    final asyncData = ref.watch(asignacionServiciosProvider);
    final serviciosAsync = ref.watch(helperServiciosForAsignacionProvider);
    final cuadrillasAsync = ref.watch(helperCuadrillasForAsignacionProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay asignaciones registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('ID ASIGNACIÓN', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('SERVICIO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('CUADRILLA', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('FECHA ASIG.', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) {
            String servicioText = e.idServicio.toString();
            serviciosAsync.whenData((items) {
              final found = items.firstWhere((s) => s['id_servicio'] == e.idServicio, orElse: () => {});
              if (found.isNotEmpty) servicioText = found['folio_interno'] ?? servicioText;
            });

            String cuadrillaText = e.idCuadrilla?.toString() ?? 'Sin Cuadrilla';
            if (e.idCuadrilla != null) {
              cuadrillasAsync.whenData((items) {
                final found = items.firstWhere((c) => c['id_cuadrilla'] == e.idCuadrilla, orElse: () => {});
                if (found.isNotEmpty) cuadrillaText = found['nombre'] ?? found['codigo'] ?? cuadrillaText;
              });
            }

            return DataRow(
              cells: [
                DataCell(Text(e.idAsignacion.toString(), style: TextStyle(color: context.textColor))),
                DataCell(Text(servicioText, style: TextStyle(color: context.textColor))),
                DataCell(Text(cuadrillaText, style: TextStyle(color: context.textColor))),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: e.estado == 'VIGENTE' 
                          ? AppColors.green.withValues(alpha: 0.1) 
                          : e.estado == 'FINALIZADA' ? AppColors.blue.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      e.estado,
                      style: TextStyle(
                        color: e.estado == 'VIGENTE' ? AppColors.green : e.estado == 'FINALIZADA' ? AppColors.blue : AppColors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(e.fechaAsignacion, style: TextStyle(color: context.textColor))),
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
          searchableValues: lista.map((e) => '${e.idAsignacion} ${e.idServicio} ${e.idCuadrilla} ${e.estado}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final serviciosAsync = ref.watch(helperServiciosForAsignacionProvider);
    final cuadrillasAsync = ref.watch(helperCuadrillasForAsignacionProvider);

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
                  Expanded(
                    flex: 2,
                    child: _buildDropdownGenerico(
                      'Cuadrilla (Opcional)', 
                      _idCuadrilla, 
                      cuadrillasAsync, 
                      'id_cuadrilla', 
                      (e) => '${e['codigo']} - ${e['nombre']}', 
                      (val) => setState(() => _idCuadrilla = val as int?),
                      allowNull: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLocalDropdown('Estado *', _estado, _estadosList, (val) => setState(() => _estado = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Fecha Asignación *', _fechaAsignacionCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateTimePicker('Inicio Vigencia *', _fechaInicioVigenciaCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDateTimePicker('Fin Vigencia', _fechaFinVigenciaCtrl)),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField('Motivo Cambio', _motivoCambioCtrl, maxLines: 2),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
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

  Widget _buildDropdownGenerico(String label, int? value, AsyncValue<List<Map<String, dynamic>>> asyncValue, String idKey, String Function(Map<String, dynamic>) labelBuilder, Function(Object?) onChanged, {bool allowNull = false}) {
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

            return DropdownButtonFormField<int?>(
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
              items: [
                if (allowNull)
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text('-- Ninguna --'),
                  ),
                ...items.map((e) => DropdownMenuItem<int?>(
                  value: e[idKey] as int,
                  child: Text(labelBuilder(e)),
                )),
              ],
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
