import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/instalacion_refaccion.dart';
import '../../providers/instalaciones_refaccion_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudInstalacionRefaccionModal extends ConsumerStatefulWidget {
  const CrudInstalacionRefaccionModal({super.key});

  @override
  ConsumerState<CrudInstalacionRefaccionModal> createState() => _CrudInstalacionRefaccionModalState();
}

class _CrudInstalacionRefaccionModalState extends ConsumerState<CrudInstalacionRefaccionModal> {
  bool _isEditing = false;
  InstalacionRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedSolicitudDetalleId;
  int? _selectedOrdenId;
  int? _selectedEquipoId;
  late TextEditingController _cantidadCtrl;
  late TextEditingController _fechaInstalacionCtrl;
  String _selectedResultado = 'EXITOSA';
  late TextEditingController _observacionCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedSolicitudDetalleId = _selectedItem?.idSolicitudRefaccionDetalle;
    _selectedOrdenId = _selectedItem?.idOrdenServicio;
    _selectedEquipoId = _selectedItem?.idEquipo;
    _cantidadCtrl = TextEditingController(text: _selectedItem?.cantidadInstalada.toString() ?? '');
    _fechaInstalacionCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaInstalacion.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    _selectedResultado = _selectedItem?.resultadoPrueba ?? 'EXITOSA';
    _observacionCtrl = TextEditingController(text: _selectedItem?.observacion ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _cantidadCtrl.dispose();
    _fechaInstalacionCtrl.dispose();
    _observacionCtrl.dispose();
    super.dispose();
  }

  void _openForm([InstalacionRefaccion? item]) {
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
    if (_selectedSolicitudDetalleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Partida Solicitada')));
      return;
    }
    if (_selectedOrdenId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Orden de Servicio')));
      return;
    }
    if (_selectedEquipoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un Equipo')));
      return;
    }

    final cant = double.tryParse(_cantidadCtrl.text) ?? 0.0;

    final item = InstalacionRefaccion(
      idInstalacion: _selectedItem?.idInstalacion,
      idSolicitudRefaccionDetalle: _selectedSolicitudDetalleId!,
      idOrdenServicio: _selectedOrdenId!,
      idEquipo: _selectedEquipoId!,
      cantidadInstalada: cant,
      fechaInstalacion: DateTime.parse(_fechaInstalacionCtrl.text),
      resultadoPrueba: _selectedResultado,
      observacion: _observacionCtrl.text.trim().isEmpty ? null : _observacionCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(instalacionesRefaccionProvider.notifier).addInstalacion(item);
      } else {
        await ref.read(instalacionesRefaccionProvider.notifier).updateInstalacion(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(InstalacionRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Instalación'),
        content: Text('¿Estás seguro de que deseas $action este registro de instalación?'),
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

    if (confirm == true && item.idInstalacion != null) {
      try {
        await ref.read(instalacionesRefaccionProvider.notifier).toggleStatus(item.idInstalacion!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = DateTime.tryParse(_fechaInstalacionCtrl.text) ?? DateTime.now();

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
        _fechaInstalacionCtrl.text = pickedDate.toIso8601String().split('T').first;
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
                        ? (_selectedItem == null ? 'Registrar Instalación' : 'Editar Instalación')
                        : 'Instalaciones de Refacciones',
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
                          label: const Text('Registrar Instalación'),
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
    final listAsync = ref.watch(instalacionesRefaccionProvider);
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForInstalacionProvider);
    final ordenesAsync = ref.watch(helperOrdenesForInstalacionProvider);
    final equiposAsync = ref.watch(helperEquiposForInstalacionProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de instalaciones.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final solicitudDetallesMap = {
          for (var item in solicitudDetallesAsync.value ?? [])
            item['id_solicitud_refaccion_detalle'] as int: () {
              final refObj = item['refaccion'] as Map<String, dynamic>?;
              final code = refObj?['codigo_interno'] ?? 'S/C';
              final desc = refObj?['descripcion_homologada'] ?? 'S/D';
              return '[$code] $desc';
            }()
        };

        final ordenesMap = {
          for (var item in ordenesAsync.value ?? [])
            item['id_orden_servicio'] as int: item['folio_orden'] as String
        };

        final equiposMap = {
          for (var item in equiposAsync.value ?? [])
            item['id_equipo'] as int: '${item['codigo_activo_cliente'] ?? 'S/C'} (${item['marca'] ?? ''} ${item['modelo'] ?? ''})'
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ORDEN DE SERVICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN SOLICITADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. INSTALADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('RESULTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('OBSERVACIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idInstalacion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(ordenesMap[item.idOrdenServicio] ?? 'Orden ID: ${item.idOrdenServicio}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(solicitudDetallesMap[item.idSolicitudRefaccionDetalle] ?? 'Detalle ID: ${item.idSolicitudRefaccionDetalle}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(equiposMap[item.idEquipo] ?? 'Equipo ID: ${item.idEquipo}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadInstalada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaInstalacion.toLocal().toString().split(' ').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.resultadoPrueba, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.observacion ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.activo ? 'Activo' : 'Inactivo',
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
            ));
      },
    );
  }

  Widget _buildForm() {
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForInstalacionProvider);
    final ordenesAsync = ref.watch(helperOrdenesForInstalacionProvider);
    final equiposAsync = ref.watch(helperEquiposForInstalacionProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Orden de Servicio & Solicitud Detalle
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orden de Servicio *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
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
                          items: (ordenesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_orden_servicio'] as int,
                              child: Text(item['folio_orden'] as String, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedOrdenId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Partida de Solicitud de Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedSolicitudDetalleId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (solicitudDetallesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final refObj = item['refaccion'] as Map<String, dynamic>?;
                            final code = refObj?['codigo_interno'] ?? 'S/C';
                            final desc = refObj?['descripcion_homologada'] ?? 'S/D';
                            final qty = item['cantidad_solicitada'];
                            return DropdownMenuItem<int>(
                              value: item['id_solicitud_refaccion_detalle'] as int,
                              child: Text('[$code] $desc (Sol: $qty)', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedSolicitudDetalleId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Equipo & Cantidad Instalada
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Equipo Destino *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedEquipoId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (equiposAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final code = item['codigo_activo_cliente'] ?? 'S/C';
                            final brand = item['marca'] ?? '';
                            final model = item['modelo'] ?? '';
                            return DropdownMenuItem<int>(
                              value: item['id_equipo'] as int,
                              child: Text('$code ($brand $model)', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedEquipoId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Instalada *', _cantidadCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Fecha Instalacion & Resultado Prueba
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha de Instalación *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaInstalacionCtrl,
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
                        Text('Resultado de Prueba *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedResultado,
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
                            DropdownMenuItem<String>(value: 'EXITOSA', child: Text('EXITOSA')),
                            DropdownMenuItem<String>(value: 'FALLIDA', child: Text('FALLIDA')),
                            DropdownMenuItem<String>(value: 'PENDIENTE DE PRUEBA', child: Text('PENDIENTE DE PRUEBA')),
                            DropdownMenuItem<String>(value: 'CON NO CONFORMIDAD', child: Text('CON NO CONFORMIDAD')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedResultado = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Observación & Activo
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField('Observación / Comentarios', _observacionCtrl),
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
