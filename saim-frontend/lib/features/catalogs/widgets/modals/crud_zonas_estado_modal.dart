import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/zona_estado.dart';
import '../../providers/zonas_estado_provider.dart';
import '../../providers/zonas_contrato_provider.dart';
import '../../providers/estados_provider.dart';
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
  int? _idZonaContrato;
  int? _idEstado;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  late TextEditingController _justificacionCtrl;
  bool _esExcepcion = false;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idZonaContrato = _selectedZona?.idZonaContrato;
    _idEstado = _selectedZona?.idEstado;
    
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
    _activo = _selectedZona?.activo ?? true;
  }

  @override
  void dispose() {
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
      idZonaContrato: _idZonaContrato ?? 1,
      idEstado: _idEstado ?? 1,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      esExcepcion: _esExcepcion,
      justificacion: _justificacionCtrl.text.trim().isEmpty ? null : _justificacionCtrl.text.trim(),
      activo: _activo,
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
    final zonasContratoAsync = ref.watch(helperZonasContratoProvider);
    final estadosAsync = ref.watch(helperEstadosProvider);

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
                    child: DropdownButtonFormField<int>(
                      value: _idZonaContrato,
                      decoration: InputDecoration(
                        labelText: 'Zona Contrato *',
                        labelStyle: TextStyle(color: context.textColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: context.backgroundColor,
                      ),
                      dropdownColor: context.surfaceColor,
                      style: TextStyle(color: context.textColor),
                      isExpanded: true,
                      items: zonasContratoAsync.when(
                        data: (list) => list.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['id'],
                            child: Text(item['nombre'], overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        loading: () => [],
                        error: (_, __) => [],
                      ),
                      onChanged: (v) => setState(() => _idZonaContrato = v),
                      validator: (v) => v == null ? 'Requerido' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _idEstado,
                      decoration: InputDecoration(
                        labelText: 'Estado *',
                        labelStyle: TextStyle(color: context.textColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: context.backgroundColor,
                      ),
                      dropdownColor: context.surfaceColor,
                      style: TextStyle(color: context.textColor),
                      isExpanded: true,
                      items: estadosAsync.when(
                        data: (list) => list.map((item) {
                          return DropdownMenuItem<int>(
                            value: item['id'],
                            child: Text(item['nombre'], overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        loading: () => [],
                        error: (_, __) => [],
                      ),
                      onChanged: (v) => setState(() => _idEstado = v),
                      validator: (v) => v == null ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField(context, 'Fecha Inicio (YYYY-MM-DD) *', _fechaInicioCtrl, required: true),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePickerField(context, 'Fecha Fin (YYYY-MM-DD)', _fechaFinCtrl),
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
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Switch(
                    value: _activo,
                    onChanged: (val) {
                      setState(() {
                        _activo = val;
                      });
                    },
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

  Widget _buildDatePickerField(BuildContext context, String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: context.mutedTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          onTap: () async {
            DateTime initialDate = DateTime.now();
            if (controller.text.isNotEmpty) {
              try {
                initialDate = DateTime.parse(controller.text);
              } catch (_) {}
            }
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: AppColors.blue,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              controller.text = picked.toIso8601String().split('T').first;
            }
          },
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
