import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/solicitud_refaccion.dart';
import '../../providers/solicitudes_refaccion_provider.dart';

class CrudSolicitudRefaccionModal extends ConsumerStatefulWidget {
  const CrudSolicitudRefaccionModal({super.key});

  @override
  ConsumerState<CrudSolicitudRefaccionModal> createState() => _CrudSolicitudRefaccionModalState();
}

class _CrudSolicitudRefaccionModalState extends ConsumerState<CrudSolicitudRefaccionModal> {
  bool _isEditing = false;
  SolicitudRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedIgualaId;
  int? _selectedOrdenId;
  int? _selectedSolicitadoPorId;
  late TextEditingController _folioCtrl;
  late TextEditingController _fechaSolicitudCtrl;
  String _selectedPrioridad = 'MEDIA';
  String _selectedEstado = 'PENDIENTE';
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedIgualaId = _selectedItem?.idIguala;
    _selectedOrdenId = _selectedItem?.idOrdenServicio;
    _selectedSolicitadoPorId = _selectedItem?.solicitadoPor;
    _folioCtrl = TextEditingController(text: _selectedItem?.folio ?? '');
    _fechaSolicitudCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaSolicitud.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    _selectedPrioridad = _selectedItem?.prioridad ?? 'MEDIA';
    _selectedEstado = _selectedItem?.estado ?? 'PENDIENTE';
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _folioCtrl.dispose();
    _fechaSolicitudCtrl.dispose();
    super.dispose();
  }

  void _openForm([SolicitudRefaccion? item]) {
    setState(() {
      _selectedItem = item;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedItem = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIgualaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Iguala')));
      return;
    }
    if (_selectedSolicitadoPorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona quién Solicita')));
      return;
    }

    final item = SolicitudRefaccion(
      idSolicitudRefaccion: _selectedItem?.idSolicitudRefaccion,
      idIguala: _selectedIgualaId!,
      idOrdenServicio: _selectedOrdenId,
      solicitadoPor: _selectedSolicitadoPorId!,
      folio: _folioCtrl.text.trim(),
      fechaSolicitud: DateTime.parse(_fechaSolicitudCtrl.text),
      prioridad: _selectedPrioridad,
      estado: _selectedEstado,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(solicitudesRefaccionProvider.notifier).addSolicitud(item);
      } else {
        await ref.read(solicitudesRefaccionProvider.notifier).updateSolicitud(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(SolicitudRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Solicitud'),
        content: Text('¿Estás seguro de que deseas $action esta solicitud de refacciones?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(item.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && item.idSolicitudRefaccion != null) {
      try {
        await ref.read(solicitudesRefaccionProvider.notifier).toggleStatus(item.idSolicitudRefaccion!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = DateTime.tryParse(_fechaSolicitudCtrl.text) ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
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

    if (pickedDate != null) {
      setState(() {
        _fechaSolicitudCtrl.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 900),
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
                    _isEditing
                        ? (_selectedItem == null ? 'Nueva Solicitud' : 'Editar Solicitud')
                        : 'Solicitudes de Refacciones',
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
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Registrar Solicitud'),
                        ),
                      const SizedBox(width: 16),
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
    final listAsync = ref.watch(solicitudesRefaccionProvider);
    final igualasAsync = ref.watch(helperIgualasForSolicitudProvider);
    final ordenesAsync = ref.watch(helperOrdenesForSolicitudProvider);
    final usuariosAsync = ref.watch(helperUsuariosForSolicitudProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay solicitudes de refacción.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final igualasMap = {
          for (var item in igualasAsync.value ?? [])
            item['id_iguala'] as int: item['codigo_iguala'] as String
        };

        final ordenesMap = {
          for (var item in ordenesAsync.value ?? [])
            item['id_orden_servicio'] as int: item['folio_orden'] as String
        };

        final usuariosMap = {
          for (var item in usuariosAsync.value ?? [])
            item['id_usuario'] as int: item['nombre_usuario'] as String
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FOLIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('IGUALA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ORDEN DE SERVICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('SOLICITADO POR', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA SOLICITUD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PRIORIDAD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idSolicitudRefaccion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.folio, style: TextStyle(color: context.textColor))),
                  DataCell(Text(igualasMap[item.idIguala] ?? 'Iguala ID: ${item.idIguala}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.idOrdenServicio != null ? (ordenesMap[item.idOrdenServicio] ?? 'Orden ID: ${item.idOrdenServicio}') : '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(usuariosMap[item.solicitadoPor] ?? 'Usuario ID: ${item.solicitadoPor}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaSolicitud.toLocal().toString().split(' ').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.prioridad, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.estado,
                        style: TextStyle(
                          color: item.activo ? AppColors.green : AppColors.red,
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
                        icon: const Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(item),
                      ),
                      IconButton(
                        icon: Icon(item.activo ? Icons.block : Icons.check_circle_outline, color: item.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(item),
                      ),
                    ],
                  )),
                ],
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    final igualasAsync = ref.watch(helperIgualasForSolicitudProvider);
    final ordenesAsync = ref.watch(helperOrdenesForSolicitudProvider);
    final usuariosAsync = ref.watch(helperUsuariosForSolicitudProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Folio & Iguala
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Folio *', _folioCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Iguala de Origen *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedIgualaId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (igualasAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_iguala'] as int,
                              child: Text(item['codigo_iguala'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedIgualaId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Orden Servicio & Solicitado Por
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orden de Servicio (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedOrdenId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: Text('Ninguna')),
                            ...(ordenesAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              return DropdownMenuItem<int?>(
                                value: item['id_orden_servicio'] as int,
                                child: Text(item['folio_orden'] as String),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedOrdenId = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Solicitado Por (Usuario) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedSolicitadoPorId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (usuariosAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_usuario'] as int,
                              child: Text(item['nombre_usuario'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedSolicitadoPorId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Fecha Solicitud & Prioridad
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha Solicitud *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaSolicitudCtrl,
                          readOnly: true,
                          style: TextStyle(color: context.textColor),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            suffixIcon: Icon(Icons.calendar_today, color: context.mutedTextColor, size: 18),
                          ),
                          onTap: _selectDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prioridad *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedPrioridad,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: const [
                            DropdownMenuItem<String>(value: 'BAJA', child: Text('BAJA')),
                            DropdownMenuItem<String>(value: 'MEDIA', child: Text('MEDIA')),
                            DropdownMenuItem<String>(value: 'ALTA', child: Text('ALTA')),
                            DropdownMenuItem<String>(value: 'URGENTE', child: Text('URGENTE')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPrioridad = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Estado & Activo
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedEstado,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: const [
                            DropdownMenuItem<String>(value: 'PENDIENTE', child: Text('PENDIENTE')),
                            DropdownMenuItem<String>(value: 'PROCESANDO', child: Text('PROCESANDO')),
                            DropdownMenuItem<String>(value: 'AUTORIZADO', child: Text('AUTORIZADO')),
                            DropdownMenuItem<String>(value: 'RECHAZADO', child: Text('RECHAZADO')),
                            DropdownMenuItem<String>(value: 'COMPLETADO', child: Text('COMPLETADO')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedEstado = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
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
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save & Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _closeForm,
                    style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
          ),
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
