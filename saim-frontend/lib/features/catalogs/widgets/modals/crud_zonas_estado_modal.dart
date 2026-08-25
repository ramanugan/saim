import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/zona_estado.dart';
import '../../providers/zonas_estado_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudZonasEstadoModal extends ConsumerStatefulWidget {
  const CrudZonasEstadoModal({super.key});

  @override
  ConsumerState<CrudZonasEstadoModal> createState() => _CrudZonasEstadoModalState();
}

class _CrudZonasEstadoModalState extends ConsumerState<CrudZonasEstadoModal> {
  bool _isEditing = false;
  ZonaEstado? _selectedZona;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idZonaContratoCtrl;
  late TextEditingController _idEstadoCtrl;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  late TextEditingController _justificacionCtrl;
  bool _esExcepcion = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idZonaContratoCtrl = TextEditingController(text: _selectedZona?.idZonaContrato.toString() ?? '');
    _idEstadoCtrl = TextEditingController(text: _selectedZona?.idEstado.toString() ?? '');
    
    _fechaInicioCtrl = TextEditingController(
      text: _selectedZona != null 
          ? _selectedZona!.fechaInicio.toIso8601String().split('T').first 
          : DateTime.now().toIso8601String().split('T').first
    );
    _fechaFinCtrl = TextEditingController(
      text: _selectedZona?.fechaFin?.toIso8601String().split('T').first ?? ''
    );
    _justificacionCtrl = TextEditingController(text: _selectedZona?.justificacion ?? '');
    _esExcepcion = _selectedZona?.esExcepcion ?? false;
  }

  @override
  void dispose() {
    _idZonaContratoCtrl.dispose();
    _idEstadoCtrl.dispose();
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _justificacionCtrl.dispose();
    super.dispose();
  }

  void _openForm([ZonaEstado? zona]) {
    setState(() {
      _selectedZona = zona;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedZona = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    DateTime fechaInicio;
    try {
      fechaInicio = DateTime.parse(_fechaInicioCtrl.text.trim());
    } catch (_) {
      fechaInicio = DateTime.now();
    }
    
    DateTime? fechaFin;
    if (_fechaFinCtrl.text.trim().isNotEmpty) {
      try {
        fechaFin = DateTime.parse(_fechaFinCtrl.text.trim());
      } catch (_) {}
    }

    final newZona = ZonaEstado(
      idZonaEstado: _selectedZona?.idZonaEstado,
      idZonaContrato: int.tryParse(_idZonaContratoCtrl.text.trim()) ?? 1,
      idEstado: int.tryParse(_idEstadoCtrl.text.trim()) ?? 1,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      esExcepcion: _esExcepcion,
      justificacion: _justificacionCtrl.text.trim().isEmpty ? null : _justificacionCtrl.text.trim(),
      activo: _selectedZona?.activo ?? true,
    );

    try {
      if (_selectedZona == null) {
        await ref.read(zonasEstadoProvider.notifier).addZonaEstado(newZona);
      } else {
        await ref.read(zonasEstadoProvider.notifier).updateZonaEstado(newZona);
      }
      _closeForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteZona(ZonaEstado zona) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Zona-Estado'),
        content: Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text('Eliminar')
          ),
        ],
      ),
    );

    if (confirm == true && zona.idZonaEstado != null) {
      try {
        await ref.read(zonasEstadoProvider.notifier).deleteZonaEstado(zona.idZonaEstado!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxWidth: 1000),
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
                    _isEditing ? (_selectedZona == null ? 'Nueva Zona-Estado' : 'Editar Zona-Estado') : 'Gestión de Zonas-Estados',
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
                          label: Text('Agregar Zona'),
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
    final zonasAsync = ref.watch(zonasEstadoProvider);

    return zonasAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (zonas) {
        if (zonas.isEmpty) {
          return Center(
            child: Text('No hay registros de zonas-estados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ZONA CONTRATO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('INICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('EXCEPCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: zonas.map((z) => DataRow(
                cells: [
                  DataCell(Text(z.idZonaContrato.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(z.idEstado.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(z.fechaInicio.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(z.esExcepcion ? 'Sí' : 'No', style: TextStyle(color: context.textColor))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(z),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                        onPressed: () => _deleteZona(z),
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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('ID Zona Contrato *', _idZonaContratoCtrl, required: true),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('ID Estado *', _idEstadoCtrl, required: true),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Fecha Inicio (YYYY-MM-DD) *', _fechaInicioCtrl, required: true),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Fecha Fin (YYYY-MM-DD)', _fechaFinCtrl),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Es Excepción', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Switch(
                    value: _esExcepcion,
                    onChanged: (val) {
                      setState(() {
                        _esExcepcion = val;
                      });
                    },
                    activeColor: AppColors.green,
                  ),
                ],
              ),
              if (_esExcepcion) ...[
                SizedBox(height: 16),
                _buildTextField('Justificación', _justificacionCtrl),
              ],
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
}
