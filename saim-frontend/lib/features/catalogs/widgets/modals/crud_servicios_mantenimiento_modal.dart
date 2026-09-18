import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/servicio_mantenimiento.dart';
import '../../providers/servicios_mantenimiento_provider.dart';
import '../../providers/iguala_servicios_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudServiciosMantenimientoModal extends ConsumerStatefulWidget {
  const CrudServiciosMantenimientoModal({super.key});

  @override
  ConsumerState<CrudServiciosMantenimientoModal> createState() => _CrudServiciosMantenimientoModalState();
}

class _CrudServiciosMantenimientoModalState extends ConsumerState<CrudServiciosMantenimientoModal> {
  bool _isEditing = false;
  ServicioMantenimiento? _selectedServicio;

  final _formKey = GlobalKey<FormState>();
  
  int? _idIguala;
  int? _idIgualaServicio;
  
  late TextEditingController _folioInternoCtrl;
  late TextEditingController _fechaSolicitudCtrl;
  late TextEditingController _fechaInicioRealCtrl;
  late TextEditingController _fechaFinRealCtrl;

  String _tipoMantenimiento = 'PREVENTIVO';
  String _origen = 'CALENDARIO';
  String _prioridad = 'MEDIA';
  String _estadoOperativo = 'PROGRAMADO';
  String _estadoDocumental = 'SIN_REPORTE';
  bool _activo = true;

  final _tiposMantenimiento = ['PREVENTIVO', 'CORRECTIVO', 'PREDICTIVO'];
  final _origenes = ['CALENDARIO', 'REPORTE_TIENDA', 'INSPECCION_TECNICA'];
  final _prioridades = ['BAJA', 'MEDIA', 'ALTA', 'CRITICA'];
  final _estadosOperativos = ['PROGRAMADO', 'EN_RUTA', 'EN_SITIO', 'TERMINADO', 'CANCELADO'];
  final _estadosDocumentales = ['SIN_REPORTE', 'REPORTE_BORRADOR', 'REPORTE_FIRMADO', 'FACTURADO'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idIguala = _selectedServicio?.idIguala == 0 ? null : _selectedServicio?.idIguala;
    _idIgualaServicio = _selectedServicio?.idIgualaServicio == 0 ? null : _selectedServicio?.idIgualaServicio;
    
    _folioInternoCtrl = TextEditingController(text: _selectedServicio?.folioInterno ?? '');
    _fechaSolicitudCtrl = TextEditingController(text: _selectedServicio?.fechaSolicitud ?? '');
    _fechaInicioRealCtrl = TextEditingController(text: _selectedServicio?.fechaInicioReal ?? '');
    _fechaFinRealCtrl = TextEditingController(text: _selectedServicio?.fechaFinReal ?? '');
    
    _tipoMantenimiento = _selectedServicio?.tipoMantenimiento ?? 'PREVENTIVO';
    if (!_tiposMantenimiento.contains(_tipoMantenimiento)) _tipoMantenimiento = _tiposMantenimiento[0];
    
    _origen = _selectedServicio?.origen ?? 'CALENDARIO';
    if (!_origenes.contains(_origen)) _origen = _origenes[0];

    _prioridad = _selectedServicio?.prioridad ?? 'MEDIA';
    if (!_prioridades.contains(_prioridad)) _prioridad = _prioridades[0];

    _estadoOperativo = _selectedServicio?.estadoOperativo ?? 'PROGRAMADO';
    if (!_estadosOperativos.contains(_estadoOperativo)) _estadoOperativo = _estadosOperativos[0];

    _estadoDocumental = _selectedServicio?.estadoDocumental ?? 'SIN_REPORTE';
    if (!_estadosDocumentales.contains(_estadoDocumental)) _estadoDocumental = _estadosDocumentales[0];

    _activo = _selectedServicio?.activo ?? true;
  }

  @override
  void dispose() {
    _folioInternoCtrl.dispose();
    _fechaSolicitudCtrl.dispose();
    _fechaInicioRealCtrl.dispose();
    _fechaFinRealCtrl.dispose();
    super.dispose();
  }

  void _openForm([ServicioMantenimiento? servicio]) {
    setState(() {
      _selectedServicio = servicio;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedServicio = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idIguala == null || _idIgualaServicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar Iguala e Iguala Servicio')));
      return;
    }
    
    final newServicio = ServicioMantenimiento(
      idServicio: _selectedServicio?.idServicio,
      idIguala: _idIguala!,
      idIgualaServicio: _idIgualaServicio!,
      tipoMantenimiento: _tipoMantenimiento,
      folioInterno: _folioInternoCtrl.text.trim(),
      origen: _origen,
      prioridad: _prioridad,
      fechaSolicitud: _fechaSolicitudCtrl.text.trim().isEmpty ? null : _fechaSolicitudCtrl.text.trim(),
      fechaInicioReal: _fechaInicioRealCtrl.text.trim().isEmpty ? null : _fechaInicioRealCtrl.text.trim(),
      fechaFinReal: _fechaFinRealCtrl.text.trim().isEmpty ? null : _fechaFinRealCtrl.text.trim(),
      estadoOperativo: _estadoOperativo,
      estadoDocumental: _estadoDocumental,
      activo: _activo,
    );

    try {
      if (_selectedServicio == null) {
        await ref.read(serviciosMantenimientoProvider.notifier).addServicioMantenimiento(newServicio);
      } else {
        await ref.read(serviciosMantenimientoProvider.notifier).updateServicioMantenimiento(newServicio);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(ServicioMantenimiento servicio) async {
    final action = servicio.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${servicio.activo ? 'Desactivar' : 'Activar'} Servicio', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action este servicio?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(servicio.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && servicio.idServicio != null) {
      try {
        await ref.read(serviciosMantenimientoProvider.notifier).deleteServicioMantenimiento(servicio.idServicio!);
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
                    _isEditing ? (_selectedServicio == null ? 'Nuevo Servicio de Mantenimiento' : 'Editar Servicio de Mantenimiento') : 'Gestión de Servicios de Mantenimiento',
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
    final serviciosAsync = ref.watch(serviciosMantenimientoProvider);

    return serviciosAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final servicios = rawList.where((e) => e.activo).toList();
        if (servicios.isEmpty) {
          return Center(
            child: Text('No hay servicios registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('FOLIO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('TIPO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ORIGEN', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('PRIORIDAD', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: servicios.map((e) => DataRow(
            cells: [
              DataCell(Text(e.folioInterno, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.tipoMantenimiento, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.origen, style: TextStyle(color: context.textColor))),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: e.prioridad == 'CRITICA' || e.prioridad == 'ALTA' 
                        ? AppColors.red.withValues(alpha: 0.1) 
                        : (e.prioridad == 'MEDIA' ? AppColors.amber.withValues(alpha: 0.2) : AppColors.blue.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    e.prioridad,
                    style: TextStyle(
                      color: e.prioridad == 'CRITICA' || e.prioridad == 'ALTA' 
                          ? AppColors.red 
                          : (e.prioridad == 'MEDIA' ? AppColors.amber : AppColors.blue),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: e.estadoOperativo == 'TERMINADO' ? AppColors.green.withValues(alpha: 0.1) : AppColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    e.estadoOperativo,
                    style: TextStyle(
                      color: e.estadoOperativo == 'TERMINADO' ? AppColors.green : AppColors.blue,
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
          searchableValues: servicios.map((e) => '${e.folioInterno} ${e.tipoMantenimiento} ${e.origen} ${e.prioridad} ${e.estadoOperativo}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final igualasAsync = ref.watch(helperIgualasForServicioProvider);
    final igualaServiciosAsync = ref.watch(igualaServiciosProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clasificación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownIgualas('Iguala *', _idIguala, igualasAsync, (val) => setState(() => _idIguala = val as int?)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownIgualaServicios('Iguala Servicio *', _idIgualaServicio, _idIguala, igualaServiciosAsync, (val) => setState(() => _idIgualaServicio = val as int?)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Folio Interno *', _folioInternoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Tipo de Mantenimiento *', _tipoMantenimiento, _tiposMantenimiento, (val) => setState(() => _tipoMantenimiento = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Origen *', _origen, _origenes, (val) => setState(() => _origen = val as String))),
                ],
              ),
              SizedBox(height: 32),
              Text('Operación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLocalDropdown('Prioridad *', _prioridad, _prioridades, (val) => setState(() => _prioridad = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Estado Operativo *', _estadoOperativo, _estadosOperativos, (val) => setState(() => _estadoOperativo = val as String))),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Estado Documental *', _estadoDocumental, _estadosDocumentales, (val) => setState(() => _estadoDocumental = val as String))),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDatePicker('Fecha de Solicitud', _fechaSolicitudCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Fecha Inicio Real', _fechaInicioRealCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Fecha Fin Real', _fechaFinRealCtrl)),
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

  Widget _buildDropdownIgualas(String label, int? value, AsyncValue<List<Map<String, dynamic>>> asyncValue, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        asyncValue.when(
          loading: () => LinearProgressIndicator(),
          error: (e, st) => Text('Error al cargar', style: TextStyle(color: AppColors.red)),
          data: (items) {
            final valueExists = items.any((e) => e['id_iguala'] == value);
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
                value: e['id_iguala'] as int,
                child: Text('ID: ${e['id_iguala']} (Tienda: ${e['id_tienda']})'), // Simplificado, ya que la info completa requiere cruces
              )).toList(),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDropdownIgualaServicios(String label, int? value, int? filterIgualaId, AsyncValue<dynamic> asyncValue, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        asyncValue.when(
          loading: () => LinearProgressIndicator(),
          error: (e, st) => Text('Error al cargar', style: TextStyle(color: AppColors.red)),
          data: (items) {
            // Filtrar servicios de iguala basados en idIguala seleccionado
            final filteredItems = (items as List).where((e) {
              if (filterIgualaId == null) return false;
              if (e.idIguala != filterIgualaId) return false;
              return e.activo;
            }).toList();

            final valueExists = filteredItems.any((e) => e.idIgualaServicio == value);
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
              items: filteredItems.map((e) => DropdownMenuItem<int>(
                value: e.idIgualaServicio as int,
                child: Text('Servicio ID: ${e.idIgualaServicio} (Tipo: ${e.idTipoServicio})'),
              )).toList(),
              onChanged: onChanged,
            );
          },
        ),
      ],
    );
  }
}
