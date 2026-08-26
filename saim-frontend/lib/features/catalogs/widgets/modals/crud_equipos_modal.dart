import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/equipo.dart';
import '../../providers/equipos_provider.dart';
import '../../providers/tipos_equipo_provider.dart';
import '../../providers/tiendas_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudEquiposModal extends ConsumerStatefulWidget {
  const CrudEquiposModal({super.key});

  @override
  ConsumerState<CrudEquiposModal> createState() => _CrudEquiposModalState();
}

class _CrudEquiposModalState extends ConsumerState<CrudEquiposModal> {
  bool _isEditing = false;
  Equipo? _selectedEquipo;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoActivoCtrl;
  late TextEditingController _marcaCtrl;
  late TextEditingController _modeloCtrl;
  late TextEditingController _numeroSerieCtrl;
  late TextEditingController _ubicacionCtrl;
  late TextEditingController _fechaInstalacionCtrl;

  int? _idTienda;
  int? _idTipoEquipo;
  String _estadoOperativo = 'OPERATIVO';
  String _criticidad = 'MEDIA';
  bool _activo = true;

  final _estadosOperativos = ['OPERATIVO', 'FUERA DE SERVICIO', 'EN MANTENIMIENTO'];
  final _nivelesCriticidad = ['BAJA', 'MEDIA', 'ALTA', 'CRÍTICA'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoActivoCtrl = TextEditingController(text: _selectedEquipo?.codigoActivoCliente ?? '');
    _marcaCtrl = TextEditingController(text: _selectedEquipo?.marca ?? '');
    _modeloCtrl = TextEditingController(text: _selectedEquipo?.modelo ?? '');
    _numeroSerieCtrl = TextEditingController(text: _selectedEquipo?.numeroSerie ?? '');
    _ubicacionCtrl = TextEditingController(text: _selectedEquipo?.ubicacionInterna ?? '');
    _fechaInstalacionCtrl = TextEditingController(text: _selectedEquipo?.fechaInstalacion ?? '');
    
    _idTienda = _selectedEquipo?.idTienda == 0 ? null : _selectedEquipo?.idTienda;
    _idTipoEquipo = _selectedEquipo?.idTipoEquipo == 0 ? null : _selectedEquipo?.idTipoEquipo;
    _estadoOperativo = _selectedEquipo?.estadoOperativo ?? 'OPERATIVO';
    _criticidad = _selectedEquipo?.criticidad ?? 'MEDIA';
    _activo = _selectedEquipo?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoActivoCtrl.dispose();
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _numeroSerieCtrl.dispose();
    _ubicacionCtrl.dispose();
    _fechaInstalacionCtrl.dispose();
    super.dispose();
  }

  void _openForm([Equipo? equipo]) {
    setState(() {
      _selectedEquipo = equipo;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedEquipo = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idTienda == null || _idTipoEquipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar tienda y tipo de equipo')));
      return;
    }
    
    final newEquipo = Equipo(
      idEquipo: _selectedEquipo?.idEquipo,
      idTienda: _idTienda!,
      idTipoEquipo: _idTipoEquipo!,
      codigoActivoCliente: _codigoActivoCtrl.text.trim().isEmpty ? null : _codigoActivoCtrl.text.trim(),
      marca: _marcaCtrl.text.trim().isEmpty ? null : _marcaCtrl.text.trim(),
      modelo: _modeloCtrl.text.trim().isEmpty ? null : _modeloCtrl.text.trim(),
      numeroSerie: _numeroSerieCtrl.text.trim().isEmpty ? null : _numeroSerieCtrl.text.trim(),
      ubicacionInterna: _ubicacionCtrl.text.trim().isEmpty ? null : _ubicacionCtrl.text.trim(),
      fechaInstalacion: _fechaInstalacionCtrl.text.trim().isEmpty ? null : _fechaInstalacionCtrl.text.trim(),
      estadoOperativo: _estadoOperativo,
      criticidad: _criticidad,
      activo: _activo,
    );

    try {
      if (_selectedEquipo == null) {
        await ref.read(equiposProvider.notifier).addEquipo(newEquipo);
      } else {
        await ref.read(equiposProvider.notifier).updateEquipo(newEquipo);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Equipo equipo) async {
    final action = equipo.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${equipo.activo ? 'Desactivar' : 'Activar'} Equipo'),
        content: Text('¿Estás seguro de que deseas $action este equipo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(equipo.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && equipo.idEquipo != null) {
      try {
        await ref.read(equiposProvider.notifier).deleteEquipo(equipo.idEquipo!);
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
        constraints: BoxConstraints(maxWidth: 1000), // Más ancho por ser multi-columna
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
                    _isEditing ? (_selectedEquipo == null ? 'Nuevo Equipo' : 'Editar Equipo') : 'Gestión de Equipos',
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
    final equiposAsync = ref.watch(equiposProvider);

    return equiposAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (equipos) {
        if (equipos.isEmpty) {
          return Center(
            child: Text('No hay equipos registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('TIENDA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIPO EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NÚMERO SERIE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO OPE.', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: equipos.map((e) => DataRow(
                cells: [
                  DataCell(Text(e.nombreTienda ?? 'N/A', style: TextStyle(color: context.textColor))),
                  DataCell(Text(e.nombreTipoEquipo ?? 'N/A', style: TextStyle(color: context.textColor))),
                  DataCell(Text(e.numeroSerie ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(e.estadoOperativo, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: e.activo ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        e.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: e.activo ? AppColors.green : AppColors.red,
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
            ));
      },
    );
  }

  Widget _buildForm() {
    final tiendasAsync = ref.watch(helperTiendasProvider);
    final tiposAsync = ref.watch(helperTiposEquipoProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información de Relación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownAsync('Tienda *', _idTienda, tiendasAsync, (val) => setState(() => _idTienda = val as int?)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownAsync('Tipo de Equipo *', _idTipoEquipo, tiposAsync, (val) => setState(() => _idTipoEquipo = val as int?)),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text('Información del Equipo', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Marca', _marcaCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Modelo', _modeloCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Número de Serie', _numeroSerieCtrl)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Código Activo Cliente', _codigoActivoCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Ubicación Interna', _ubicacionCtrl)),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField('Fecha Instalación (YYYY-MM-DD)', _fechaInstalacionCtrl)),
                ],
              ),
              SizedBox(height: 32),
              Text('Estado y Operación', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildLocalDropdown('Estado Operativo *', _estadoOperativo, _estadosOperativos, (v) => setState(() => _estadoOperativo = v.toString()))),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Criticidad *', _criticidad, _nivelesCriticidad, (v) => setState(() => _criticidad = v.toString()))),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
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
            return DropdownButtonFormField<int>(
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
              items: items.map((e) => DropdownMenuItem<int>(
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
