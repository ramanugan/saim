import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/cuadrilla.dart';
import '../../providers/cuadrillas_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudCuadrillasModal extends ConsumerStatefulWidget {
  const CrudCuadrillasModal({super.key});

  @override
  ConsumerState<CrudCuadrillasModal> createState() => _CrudCuadrillasModalState();
}

class _CrudCuadrillasModalState extends ConsumerState<CrudCuadrillasModal> {
  bool _isEditing = false;
  Cuadrilla? _selectedCuadrilla;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;

  int? _idZonaBase;
  String _estatus = 'ACTIVA';
  bool _activo = true;

  final _estatusList = ['ACTIVA', 'INACTIVA', 'SUSPENDIDA'];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedCuadrilla?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedCuadrilla?.nombre ?? '');
    
    _idZonaBase = _selectedCuadrilla?.idZonaBase == 0 ? null : _selectedCuadrilla?.idZonaBase;

    _estatus = _selectedCuadrilla?.estatus ?? 'ACTIVA';
    if (!_estatusList.contains(_estatus)) _estatus = _estatusList[0];

    _activo = _selectedCuadrilla?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _openForm([Cuadrilla? cuadrilla]) {
    setState(() {
      _selectedCuadrilla = cuadrilla;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedCuadrilla = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newCuadrilla = Cuadrilla(
      idCuadrilla: _selectedCuadrilla?.idCuadrilla,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      idZonaBase: _idZonaBase,
      estatus: _estatus,
      activo: _activo,
    );

    try {
      if (_selectedCuadrilla == null) {
        await ref.read(cuadrillasProvider.notifier).addCuadrilla(newCuadrilla);
      } else {
        await ref.read(cuadrillasProvider.notifier).updateCuadrilla(newCuadrilla);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Cuadrilla cuadrilla) async {
    final action = cuadrilla.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${cuadrilla.activo ? 'Desactivar' : 'Activar'} Cuadrilla', style: TextStyle(color: context.textColor)),
        backgroundColor: context.surfaceColor,
        content: Text('¿Estás seguro de que deseas $action esta cuadrilla?', style: TextStyle(color: context.textColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar', style: TextStyle(color: context.mutedTextColor))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(cuadrilla.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && cuadrilla.idCuadrilla != null) {
      try {
        await ref.read(cuadrillasProvider.notifier).deleteCuadrilla(cuadrilla.idCuadrilla!);
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
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(maxWidth: 800),
        height: MediaQuery.of(context).size.height * 0.8,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? (_selectedCuadrilla == null ? 'Nueva Cuadrilla' : 'Editar Cuadrilla') : 'Gestión de Cuadrillas',
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
    final asyncData = ref.watch(cuadrillasProvider);

    return asyncData.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (rawList) {
        final lista = rawList.where((e) => e.activo).toList();
        if (lista.isEmpty) {
          return Center(
            child: Text('No hay cuadrillas registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(
          columns: [
            DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
            DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
          ],
          rows: lista.map((e) => DataRow(
            cells: [
              DataCell(Text(e.codigo, style: TextStyle(color: context.textColor))),
              DataCell(Text(e.nombre, style: TextStyle(color: context.textColor))),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: e.estatus == 'ACTIVA' ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    e.estatus,
                    style: TextStyle(
                      color: e.estatus == 'ACTIVA' ? AppColors.green : AppColors.red,
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
          searchableValues: lista.map((e) => '${e.codigo} ${e.nombre} ${e.estatus}').toList(),
        );
      },
    );
  }

  Widget _buildForm() {
    final zonasAsync = ref.watch(helperZonasContratoForCuadrillaProvider);

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
                  Expanded(child: _buildTextField('Código *', _codigoCtrl, required: true)),
                  SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildTextField('Nombre *', _nombreCtrl, required: true)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownZonas('Zona Base', _idZonaBase, zonasAsync, (val) => setState(() => _idZonaBase = val as int?)),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: _buildLocalDropdown('Estatus *', _estatus, _estatusList, (val) => setState(() => _estatus = val as String))),
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

  Widget _buildDropdownZonas(String label, int? value, AsyncValue<List<Map<String, dynamic>>> asyncValue, Function(Object?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        asyncValue.when(
          loading: () => LinearProgressIndicator(),
          error: (e, st) => Text('Error al cargar', style: TextStyle(color: AppColors.red)),
          data: (items) {
            final valueExists = items.any((e) => e['id_zona_contrato'] == value);
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
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text('-- Ninguna --'),
                ),
                ...items.map((e) => DropdownMenuItem<int?>(
                  value: e['id_zona_contrato'] as int,
                  child: Text('${e['nombre']}'),
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
