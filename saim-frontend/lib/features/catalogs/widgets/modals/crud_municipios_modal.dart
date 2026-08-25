import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/municipio.dart';
import '../../providers/municipios_provider.dart';
import '../../providers/estados_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudMunicipiosModal extends ConsumerStatefulWidget {
  const CrudMunicipiosModal({super.key});

  @override
  ConsumerState<CrudMunicipiosModal> createState() => _CrudMunicipiosModalState();
}

class _CrudMunicipiosModalState extends ConsumerState<CrudMunicipiosModal> {
  bool _isEditing = false;
  Municipio? _selectedMunicipio;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _claveInegiCtrl;

  int? _selectedEstadoId;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nombreCtrl = TextEditingController(text: _selectedMunicipio?.nombre ?? '');
    _claveInegiCtrl = TextEditingController(text: _selectedMunicipio?.claveInegi ?? '');
    _selectedEstadoId = _selectedMunicipio?.idEstado;
    _activo = _selectedMunicipio?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _claveInegiCtrl.dispose();
    super.dispose();
  }

  void _openForm([Municipio? municipio]) {
    setState(() {
      _selectedMunicipio = municipio;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedMunicipio = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEstadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, selecciona un estado.')));
      return;
    }
    
    final newMunicipio = Municipio(
      idMunicipio: _selectedMunicipio?.idMunicipio,
      idEstado: _selectedEstadoId!,
      nombre: _nombreCtrl.text.trim(),
      claveInegi: _claveInegiCtrl.text.trim().isEmpty ? null : _claveInegiCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedMunicipio == null) {
        await ref.read(municipiosProvider.notifier).addMunicipio(newMunicipio);
      } else {
        await ref.read(municipiosProvider.notifier).updateMunicipio(newMunicipio);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Municipio municipio) async {
    final action = municipio.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${municipio.activo ? 'Desactivar' : 'Activar'} Municipio'),
        content: Text('¿Estás seguro de que deseas $action este municipio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(municipio.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && municipio.idMunicipio != null) {
      try {
        await ref.read(municipiosProvider.notifier).toggleStatus(municipio.idMunicipio!, municipio.activo);
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
        constraints: BoxConstraints(maxWidth: 800),
        height: 600,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? (_selectedMunicipio == null ? 'Nuevo Municipio' : 'Editar Municipio') : 'Gestión de Municipios',
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
                          label: Text('Agregar Municipio'),
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
    final municipiosAsync = ref.watch(municipiosProvider);

    return municipiosAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (municipios) {
        if (municipios.isEmpty) {
          return Center(
            child: Text('No hay municipios registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CLAVE INEGI', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: municipios.map((m) => DataRow(
                cells: [
                  DataCell(Text(m.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(Text(m.claveInegi ?? '', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: m.activo ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        m.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: m.activo ? AppColors.green : AppColors.red,
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
                        onPressed: () => _openForm(m),
                      ),
                      IconButton(
                        icon: Icon(m.activo ? Icons.block : Icons.check_circle_outline, color: m.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(m),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEstadoDropdown(),
              SizedBox(height: 16),
              _buildTextField('Nombre *', _nombreCtrl, required: true),
              SizedBox(height: 16),
              _buildTextField('Clave INEGI', _claveInegiCtrl),
              SizedBox(height: 24),
              Row(
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

  Widget _buildEstadoDropdown() {
    final estadosAsync = ref.watch(estadosProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estado *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        estadosAsync.when(
          loading: () => CircularProgressIndicator(),
          error: (err, st) => Text('Error: $err', style: TextStyle(color: AppColors.red)),
          data: (estados) {
            final activeEstados = estados.where((e) => e.activo).toList();
            if (activeEstados.isEmpty && _selectedEstadoId == null) {
              return Text('No hay estados activos', style: TextStyle(color: context.mutedTextColor));
            }
            return DropdownButtonFormField<int>(
              value: _selectedEstadoId,
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
              dropdownColor: context.surfaceColor,
              items: activeEstados.map((e) => DropdownMenuItem<int>(
                value: e.idEstado,
                child: Text(e.nombre, style: TextStyle(color: context.textColor)),
              )).toList(),
              onChanged: (val) {
                setState(() => _selectedEstadoId = val);
              },
              validator: (v) => v == null ? 'Requerido' : null,
            );
          },
        ),
      ],
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
}
